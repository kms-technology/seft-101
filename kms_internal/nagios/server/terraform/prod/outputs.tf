output "machine_id" {
  value = aws_instance.nagios.arn
}

output "public_ip" {
  value = aws_eip.nagios.public_ip
}