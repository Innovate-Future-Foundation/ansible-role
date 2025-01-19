provider "aws" {
  region = "ap-southeast-2"  
}

resource "aws_instance" "jenkins_master" {
  ami           = "ami-040e71e7b8391cae4" 
  instance_type = var.instance_type
  key_name      = var.key_name

  tags = {
    Name = "Inff-Jenkins-Master"
  }
  root_block_device {
  volume_size           = 20 
  volume_type           = "gp2" 
  delete_on_termination = true 
  }

  security_groups = ["inff-jenkins-master-sg"]

}

resource "aws_instance" "jenkins_slave" {
  count         = var.slave_count
  ami           = "ami-040e71e7b8391cae4" 
  instance_type = var.instance_type
  key_name      = var.key_name
  tags = {
    Name = "Inff-Jenkins-Slave-${count.index + 1}"
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

resource "aws_security_group" "inff-jenkins-slave-sg"{
    name="inff-jenkins-slave-sg"
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
terraform {
  backend "s3" {
    bucket         = "terraform-states-for-jenkins-inff"
    key            = "./terraform.tfstate"  
    region         = "ap-southeast-2"           
    dynamodb_table = "terraform-lock-table"    
    encrypt        = true                       
  }
}
resource "local_file" "inventory" {
  content = <<EOT
all:
  children:
    master:
      hosts:
        master-node:
          ansible_host: ${aws_instance.jenkins_master.public_ip}
          ansible_host_alias: ${aws_instance.jenkins_master.public_ip}
          ansible_user: ubuntu
          ansible_port: 22
          ansible_ssh_private_key_file: ${var.ssh_private_key}
          ansible_ssh_extra_args: '-o StrictHostKeyChecking=no'
    worker:
      hosts:
%{ for i, instance in aws_instance.jenkins_slave ~}
        worker-${i + 1}-node:
          ansible_host: ${instance.public_ip}
          ansible_host_alias: worker-${i + 1}
          ansible_user: ubuntu
          ansible_port: 22
          ansible_ssh_private_key_file: ${var.ssh_private_key}
          ansible_ssh_extra_args: '-o StrictHostKeyChecking=no'
%{ endfor ~}
EOT
  filename = "${path.module}/inventory.yml"
}

resource "null_resource" "ansible_provision" {
    provisioner "local-exec"{
        command = "export ANSIBLE_CONFIG=${path.module}/../ansible.cfg && sleep 60 && ansible-playbook -i ${local_file.inventory.filename} ../roles/jenkins/tests/ansible-playbook.yml "
        # command = "sleep 60 && ansible-playbook -i ${local_file.inventory.filename} ../roles/ansible-role-jenkins-playbook-test.yml"

    }
  depends_on = [ aws_instance.jenkins_master, aws_instance.jenkins_slave ]
}