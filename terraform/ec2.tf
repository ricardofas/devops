variable "ami_id" {
  description = "AMI ID to use for the EC2 instance"
  type        = string
}

variable "subnet_id" {
  description = "Subnet where the EC2 instance will be created"
  type        = string
}

variable "key_name" {
  description = "Optional SSH key pair name"
  type        = string
  default     = null
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "m5-xlarge-ec2"
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2-basic-sg"
  description = "Basic EC2 security group"
  vpc_id      = data.aws_subnet.selected.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-basic-sg"
  }
}

data "aws_subnet" "selected" {
  id = var.subnet_id
}

resource "aws_instance" "this" {
  ami                         = var.ami_id
  instance_type               = "m5.xlarge"
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  tags = {
    Name = var.instance_name
  }
}

output "instance_id" {
  value = aws_instance.this.id
}

output "public_ip" {
  value = aws_instance.this.public_ip
}

output "private_ip" {
  value = aws_instance.this.private_ip
}
