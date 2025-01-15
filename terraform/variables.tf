# instance type
variable "instance_type" {
  description = "The type of EC2 instance to create"
  default     = "t2.micro"
}

# SSH KEY NAME
variable "key_name" {
  description = "The name of the SSH key to use"
}

# PRIVATE KEY PATH
variable "ssh_private_key" {
  description = "The path to the SSH private key file"
}
