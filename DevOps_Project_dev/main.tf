provider "aws" {
  region = "eu-north-1"
}

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.example.public_key_openssh
}

resource "aws_instance" "jenkins" {
  ami                    = "ami-0b87edaa84d7c45ce"
  instance_type          = "t3.micro"
  user_data = "${file("jenkins_server_userdata.sh")}"
  vpc_security_group_ids = [aws_security_group.devops.id]
  key_name = aws_key_pair.generated_key.key_name
  tags = {
    Name  = "Jenkins_server"
    Owner = "Artem Shakhov"
  }
}

resource "aws_instance" "tomcat" {
  ami                    = "ami-0b87edaa84d7c45ce"
  instance_type          = "t3.micro"
  user_data = "${file("tomcat_server_userdata.sh")}"
  vpc_security_group_ids = [aws_security_group.devops.id]
  key_name = aws_key_pair.generated_key.key_name
  tags = {
    Name  = "Tomcat_server"
    Owner = "Artem Shakhov"
  }
}

resource "aws_instance" "kubernetes" {
  ami                    = "ami-0b87edaa84d7c45ce"
  instance_type          = "t3.micro"
  user_data = "${file("kubernetes_server_userdata.sh")}"
  vpc_security_group_ids = [aws_security_group.devops.id]
  iam_instance_profile = aws_iam_instance_profile.eksctl_profile.name
  key_name = aws_key_pair.generated_key.key_name
  tags = {
    Name  = "kubernetes_server"
    Owner = "Artem Shakhov"
  }
}

resource "aws_security_group" "devops" {
  name        = "Devops Security Group"
  description = "Security Group for Jenkins_Server"

  ingress {
    from_port   = 8080
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name  = "terraform"
  }
}
