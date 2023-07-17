terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  //required_version = ">= 1.2.0"
}
provider "aws" {
  region  = "eu-west-3"
  profile = "default"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20220420"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
resource "tls_private_key" "custom_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name_prefix = "Jenkins-SSH-Key"
  public_key      = tls_private_key.custom_key.public_key_openssh
  provisioner "local-exec" {
    command = "echo '${tls_private_key.custom_key.private_key_pem}' > ../key.pem"
  }
}

resource "aws_security_group" "jenkins_security_group" {
  name        = "jenkins_security_group"
  description = "Security group to allow inbound SCP & outbound 8080 Jenkins connections"

  ingress {
    description = "Inbound SCP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Inbound SCP"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 32768
    to_port     = 60999
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 50000
    to_port     = 50000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkins_security_group"
  }
}
resource "aws_instance" "jenkins" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.medium"

  key_name        = aws_key_pair.generated_key.key_name
  security_groups = [aws_security_group.jenkins_security_group.name]
  root_block_device {
    volume_size = 20
  }
  tags = {
    Name = "jenkins_ec2"
  }

  user_data = <<EOF
#!/bin/bash

echo "-------------------------START SETUP---------------------------"
sudo apt-get -y update
sudo apt-get -y install openjdk-11-jre
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get -y update
sudo apt-get -y install jenkins
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
    sudo apt -y install apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
    
    apt-cache policy docker-ce

    sudo apt -y install docker-ce
    sudo usermod -aG docker $${USER}
    sudo usermod -a -G docker jenkins
    sudo service jenkins restart
    sudo systemctl daemon-reload
    sudo service docker stop
    sudo service docker start

echo "-------------------------END SETUP---------------------------"

EOF
}
resource "aws_instance" "cart" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.medium"

  key_name        = aws_key_pair.generated_key.key_name
  security_groups = [aws_security_group.jenkins_security_group.name]
  root_block_device {
    volume_size = 20
  }
  tags = {
    Name = "cart_ec2"
  }

  user_data = <<EOF
#!/bin/bash

echo "-------------------------START SETUP---------------------------"
sudo apt-get -y update
sudo apt-get -y install openjdk-11-jre
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get -y update
sudo apt-get -y install jenkins
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
    sudo apt -y install apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
    
    apt-cache policy docker-ce

    sudo apt -y install docker-ce
    sudo usermod -aG docker $${USER}
    sudo usermod -a -G docker jenkins
    sudo service jenkins restart
    sudo systemctl daemon-reload
    sudo service docker stop
    sudo service docker start

echo "-------------------------END SETUP---------------------------"

EOF
}
