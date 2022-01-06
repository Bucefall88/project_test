#----------------------------------------------------------------------- 
# Name:		project-test
# Version:	1.0	
#
#-----------------------------------------------------------------------
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
  shared_credentials_file = var.aws_credentials
}
# Key-Pair
resource "aws_key_pair" "deployer" {
  key_name   = "project-test-key"
  public_key = file(var.public_key)
}
# Create instances
# c8.local
resource "aws_instance" "c8" {
  ami           = "ami-06ec8443c2a35b0ba"
  instance_type = "t2.micro"
  key_name	= "project-test-key"
  root_block_device { 
    volume_size = 10 
  }
  private_ip                    = "10.10.0.101"
  subnet_id                     = aws_subnet.subnet_test.id
  vpc_security_group_ids	= [aws_security_group.sg_test.id]
  depends_on                    = [aws_internet_gateway.gw_test]
  tags = {
    Name = "c8.local"
  }
  provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready'"]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.privat_key)
      host        = self.public_ip
    }
  }
}

# u21.local
resource "aws_instance" "u21" {
  ami           = "ami-0d527b8c289b4af7f"
  instance_type = "t2.micro"
  key_name	= "project-test-key"
  root_block_device {
    volume_size = 10
  }
  private_ip			= "10.10.0.11"
  subnet_id			= aws_subnet.subnet_test.id
  vpc_security_group_ids	= [aws_security_group.sg_test.id]
  depends_on                    = [aws_internet_gateway.gw_test]
  tags = {
    Name = "u21.local"
  }
  provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready'"]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.privat_key)
      host        = self.public_ip
    }
  }
}

# Generate inventory for ansible
resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/ansible/hosts.tpl",
    {
      frontend = aws_instance.c8.*.public_ip
      backend  = aws_instance.u21.*.public_ip
    }
  )
  filename = "${path.module}/ansible/hosts.cfg"
}

# Preparing VM with Ansible
resource null_resource "ansible" {
  provisioner "local-exec" {
    command  = "export ANSIBLE_HOST_KEY_CHECKING=False; ansible-playbook -i '${path.module}/ansible/hosts.cfg' --private-key var.privat_key ansible/preparing.yaml"
  }
  depends_on = [aws_instance.c8, aws_instance.u21, local_file.hosts_cfg]
}
