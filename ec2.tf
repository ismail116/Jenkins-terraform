

provider "aws" {
  region = "us-east-1"  # Set your desired AWS region
  -- access_key = var.AWS_ACCESS_KEY_ID
  -- secret_key = var.AWS_SECRET_ACCESS_KEY
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"  # Ubuntu 20.04 LTS AMI ID, change to your desired AMI
  instance_type = "t2.micro"                # Set your desired instance type
}

output "public_ip" {
  value = aws_instance.example.public_ip
}
