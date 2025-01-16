# instance type
variable "instance_type" {
  description = "The type of EC2 instance to create"
  default     = "t2.micro"
}

# SSH KEY NAME
variable "key_name" {
  description = "The name of the SSH key to use"
  default = "JR-DEVOPS"
}

# PRIVATE KEY PATH
variable "ssh_private_key" {
  description = "The path to the SSH private key file"
  default = "~/JR-DEVOPS.pem"
}
# variable "master_node" {
#   default = {
#     name            = "master-node"
#     alias           = "jenkins-master"
#     ansible_user    = "root"
#     ansible_port    = 23
#     private_key     = "~/.ssh/id_rsa"
#   }
# }
# variable "worker_nodes" {
#   default = [
#     {
#       name            = "worker-1-node"
#       alias           = "jenkins-worker1"
#       ansible_host    = "localhost"
#       ansible_user    = "root"
#       ansible_port    = 24
#       private_key     = "~/.ssh/id_rsa"
#     }
#   ]
# }