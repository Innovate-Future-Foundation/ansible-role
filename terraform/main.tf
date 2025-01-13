provider "aws" {
  region = "ap-southeast-2"  
}

resource "aws_instance" "jenkins_master" {
  ami           = "ami-040e71e7b8391cae4" 
  instance_type = "t2.small"
  key_name      = "inff-jenkins-master"
  tags = {
    Name = "Inff-Jenkins-Master"
  }

  security_groups = ["inff-jenkins-master-sg"]

}

resource "aws_instance" "jenkins_slave" {
  ami           = "ami-040e71e7b8391cae4" 
  instance_type = "t2.micro"
  key_name      = "inff-jenkins-slave"
  tags = {
    Name = "Inff-Jenkins-Slave"
  }

  security_groups = ["inff-jenkins-slave-sg"]

}

resource "aws_security_group" "inff-jenkins-master-sg" {
  name        = "inff-jenkins-master-sg"
  description = "Allow SSH and Jenkins traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
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
}

resource "aws_security_group" "inff-jenkins-master-sg"{
    name="inff-jenkins-slave-sg"
    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_security_group.inff-jenkins_master-sg.id]
  }
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}