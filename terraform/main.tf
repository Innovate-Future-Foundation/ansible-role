provider "aws" {
  region = "ap-southeast-2"  
}

resource "aws_instance" "jenkins_master" {
  ami           = "ami-040e71e7b8391cae4" 
  instance_type = var.instance_type
  key_name      = var.key_name

  user_data = <<-EOF
              #!/bin/bash
              echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
              EOF
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
  ami           = "ami-040e71e7b8391cae4" 
  instance_type = var.instance_type
  key_name      = var.key_name
  user_data = <<-EOF
              #!/bin/bash
              echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
              EOF
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
# resource "aws_security_group_rule" "slave_allow_ssh_from_master" {
#     type                     = "ingress"
#     from_port                = 22
#     to_port                  = 22
#     protocol                 = "tcp"
#     security_group_id        = aws_security_group.inff-jenkins-slave-sg.id
#     source_security_group_id = aws_security_group.inff-jenkins-master-sg.id
# }
# resource "local_file" "inventory" {
#   content = <<EOT
# [test]
# ${aws_instance.jenkins_master.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=${var.ssh_private_key} ansible_ssh_extra_args='-o StrictHostKeyChecking=no'
#   EOT
#   filename = "${path.module}/inventory.ini"
# }
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
        worker-1-node:
          ansible_host: ${aws_instance.jenkins_slave.public_ip}
          ansible_host_alias: ${aws_instance.jenkins_slave.public_ip}
          ansible_user: ubuntu
          ansible_port: 22
          ansible_ssh_private_key_file: ${var.ssh_private_key}
          ansible_ssh_extra_args: '-o StrictHostKeyChecking=no'
EOT
  filename = "${path.module}/inventory.yml"
}

resource "null_resource" "ansible_provision" {
    provisioner "local-exec"{
        command = "export ANSIBLE_CONFIG=${path.module}/../ansible.cfg && sleep 60 && ansible-playbook -i ${local_file.inventory.filename} ../roles/jenkins/tests/ansible-playbook.yml "
        # command = "sleep 60 && ansible-playbook -i ${local_file.inventory.filename} ../roles/ansible-role-jenkins-playbook-test.yml"

    }
  depends_on = [ aws_instance.jenkins_master ]
}