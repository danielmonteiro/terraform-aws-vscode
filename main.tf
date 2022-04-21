resource "aws_vpc" "vscode_terraform_vpc" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "vscode_terraform"
  }
}

resource "aws_subnet" "vscode_terraform_public_subnet" {
  vpc_id                  = aws_vpc.vscode_terraform_vpc.id
  cidr_block              = "10.123.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "sa-east-1a"

  tags = {
    "Name" = "vscode_terraform_public_subnet"
  }
}

resource "aws_internet_gateway" "vscode_terraform_internet_gateway" {
  vpc_id = aws_vpc.vscode_terraform_vpc.id

  tags = {
    "Name" = "vscode_terraform_internet_gateway"
  }
}

resource "aws_route_table" "vscode_terraform_route_table" {
  vpc_id = aws_vpc.vscode_terraform_vpc.id

  tags = {
    "Name" = "vscode_terraform_route_table"
  }
}

resource "aws_route" "vscode_terraform_default_route" {
  route_table_id         = aws_route_table.vscode_terraform_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vscode_terraform_internet_gateway.id
}

resource "aws_route_table_association" "vscode_terraform_rt_association" {
  subnet_id      = aws_subnet.vscode_terraform_public_subnet.id
  route_table_id = aws_route_table.vscode_terraform_route_table.id
}

resource "aws_security_group" "vscode_terraform_security_group" {
  name        = "vscode_terraform_security_group"
  description = "dev security group"
  vpc_id      = aws_vpc.vscode_terraform_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["189.78.206.164/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "vscode_terraform_key_pair" {
  key_name   = "vscode_terraform_key_pair"
  public_key = file("/home/daniel/.ssh/vscode_terraform.pub")
}

resource "aws_instance" "vscode_terraform_instance" {
  instance_type = "t2.micro"
  ami = data.aws_ami.vscode_terraform_ami.id
  key_name = aws_key_pair.vscode_terraform_key_pair.id
  vpc_security_group_ids = [aws_security_group.vscode_terraform_security_group.id]
  subnet_id = aws_subnet.vscode_terraform_public_subnet.id
  user_data = file("userdata.tpl")

  root_block_device {
    volume_size = 10
  }

  tags = {
    "Name" = "vscode_terraform_instance"
  }

  provisioner "local-exec" {
    command = templatefile("${var.host_os}-ssh-config.tpl", {
      hostname = self.public_ip,
      user = "ubuntu",
      identityfile = "~/.ssh/vscode_terraform"
    })
    interpreter = ["bash", "-c"]
  }
}