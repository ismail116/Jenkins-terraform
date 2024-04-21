provider "aws" {
  region = "us-east-1"  
}

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "ec2-key-pair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDIuo6QWk49ShuRwBNqtQQEo0RDjt64BY5WIo3iBYV71FYDs/ZACBUtpF2kTGqxsBtsz/ZZCe9yn4em+gg3xEHM0bwUUbpCz1mlExYlxkJBiARbxdwhmqoOHI61hwLFEMPFzTUdp1DLBkBbVm6mz2UtECcPCnTt+vuDPL3fmWZoQGpcJpkFmHpkQmUsR67c343QmFoPYZ3MOTT/vqFUSYSsad24NAHXmVgX3SNwj6dfeSUZFhbf6L3wBwvtXD722OM6oaIMhG6oN5PLi8fV0C+XtzvxwZ9mMN+cbuJRc33YtuuH9Nhh2Wqr9iQqz8LzqFxsaRUhWy466FwaH+sob9SH ismail@ismail"
}

resource "aws_instance" "task_ec2" {
  ami           = "ami-080e1f13689e07408"  
  instance_type = "t2.micro"                

  key_name = aws_key_pair.ec2_key_pair.key_name

  // Associate the instance with a security group
  vpc_security_group_ids = [aws_security_group.task_sg.id]
}

resource "aws_security_group" "task_sg" {
  name        = "ec2-security-group"
  description = "Security group for example instance"

  // Ingress rule for SSH (port 22)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH access from anywhere
  }

  // Ingress rule for ICMP (ping)
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow ping from anywhere
  }
 // Ingress rule for HTTP (port 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP access from anywhere
  }
  // Egress rule allowing all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// Output the public IP address of the instance
# output "public_ip" {
#   value = aws_instance.task_ec2.public_ip
# }

resource "local_file" "public_ip_file" {
   filename= "inventory"
   content= aws_instance.task_ec2.public_ip 
}
