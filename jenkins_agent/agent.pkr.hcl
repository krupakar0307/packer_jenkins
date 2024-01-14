## Packer Plugin for aws
packer {
  required_plugins {
    amazon = {
      version = " >= 1.2.9"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

// data block to retrive ami id from specific region

data "amazon-ami" "jenkins-agent-ami" {
  filters = {
    virtualization-type = "hvm"
    name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
    root-device-type    = "ebs"
  }
  owners      = ["amazon"]
  most_recent = true
  region      = var.region
}

// in a local
locals {
  source_ami_id   = data.amazon-ami.jenkins-agent-ami.id
}

## source block for reuseable builder configuration
source "amazon-ebs" "jenkins-agent-ami" {
  ami_name                                  = "jenkins_agent_{{timestamp}}"
  instance_type                             = var.instance_type
  region                                    = var.region
  source_ami                                = local.source_ami_id
  ssh_username                              = "ubuntu"
  temporary_security_group_source_public_ip = true
  # vpc_id = var.vpc_id
  # subnet_id = var.subnet_id
  launch_block_device_mappings {
    device_name           = "/dev/sda1"
    delete_on_termination = true
    encrypted             = true
    volume_size           = 8
    volume_type           = "gp2"
  }
  tags = {
    Name = "Jenkins_agent_AMI"
  }
}
## Builder block to build an ami on above base ami with below provisioned packages.
build {
  sources = ["source.amazon-ebs.jenkins-agent-ami"]
  provisioner "file" {
    source      = "jenkins_agent.sh"
    destination = "/tmp/jenkins_agent.sh"
  }
  provisioner "shell" {
    inline = [
      "cd /tmp && chmod +x /tmp/jenkins_agent.sh",
      "sh jenkins_agent.sh && rm jenkins_agent.sh"
    ]
  }
}

