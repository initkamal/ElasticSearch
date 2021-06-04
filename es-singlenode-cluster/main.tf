data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_security_group" "security_group" {
  name        = var.security_group
  description = "Allow TLS inbound traffic"


  dynamic "ingress" {
    for_each = var.security_group_ports
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  tags = {
    Name = var.security_group
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}

resource "aws_eip" "elastic_ip" {

  instance = aws_instance.elasticsearch_instance.id
  vpc      = true

  tags = {
    Name = var.elasticsearch_instance
  }

}


resource "aws_key_pair" "elasticsearch_deployer_key" {
  key_name   = var.key_pair
  public_key = file("${path.module}/ssh-key/id_rsa.pub")

}



resource "aws_instance" "elasticsearch_instance" {

  ami             = data.aws_ami.ubuntu.id
  instance_type   = var.instance_type
  security_groups = ["${var.security_group}"]
  key_name        = aws_key_pair.elasticsearch_deployer_key.id

  tags = {
    Name = var.elasticsearch_instance
  }

  provisioner "remote-exec" {
    inline = ["sudo apt update", "sudo apt upgrade -y", "sudo apt install python3 -y", "echo Bootstrapping of the instances done!"]

    connection {
      host        = self.public_ip
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${path.module}/ssh-key/id_rsa")
    }
  }

  provisioner "local-exec" {

    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu -i '${self.public_ip},' --private-key ssh-key/id_rsa  elasticsearch_provisioning.yml"

  }

}


