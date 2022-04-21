output "instance_ip" {
  value = aws_instance.vscode_terraform_instance.public_ip
}