provider "aws" {
  region = "us-east-1"  # Set your desired AWS region
}

resource "aws_key_pair" "example_key_pair" {
  key_name   = "example-key-pair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDIuo6QWk49ShuRwBNqtQQEo0RDjt64BY5WIo3iBYV71FYDs/ZACBUtpF2kTGqxsBtsz/ZZCe9yn4em+gg3xEHM0bwUUbpCz1mlExYlxkJBiARbxdwhmqoOHI61hwLFEMPFzTUdp1DLBkBbVm6mz2UtECcPCnTt+vuDPL3fmWZoQGpcJpkFmHpkQmUsR67c343QmFoPYZ3MOTT/vqFUSYSsad24NAHXmVgX3SNwj6dfeSUZFhbf6L3wBwvtXD722OM6oaIMhG6oN5PLi8fV0C+XtzvxwZ9mMN+cbuJRc33YtuuH9Nhh2Wqr9iQqz8LzqFxsaRUhWy466FwaH+sob9SH ismail@ismail"
}

resource "aws_instance" "example" {
  ami           = "ami-080e1f13689e07408"  # Ubuntu 20.04 LTS AMI ID, change to your desired AMI
  instance_type = "t2.micro"                # Set your desired instance type

  key_name = aws_key_pair.example_key_pair.key_name  # Use the created key pair for SSH authentication
}

# output "public_ip" {
#   value = aws_instance.example.public_ip
# }

resource "local_file" "public_ip_file" {
   filename= "inventory"
   content= aws_instance.example.public_ip 
}
