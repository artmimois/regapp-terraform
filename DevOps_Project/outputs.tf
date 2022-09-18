output "private_key" {
  value     = tls_private_key.example.private_key_pem
  sensitive = true
}

output "aws_instance_public_ip" {
  value = ["Jenkins Server IP: ${aws_instance.jenkins.public_ip} \nTomcat Server IP: ${aws_instance.tomcat.public_ip}"]
}

