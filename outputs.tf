# add output
output "IP" {
  value = aws_instance.res-web.public_ip
}

output "DNS" {
  value = aws_instance.res-web.public_dns
}