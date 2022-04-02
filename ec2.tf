resource "aws_instance" "ami" {
  ami = data.aws_ami.ami.id
  instance_type = "t3.small"
  vpc_security_group_ids = [aws_security_group.sg.id]
  tags = {
    Name = "${var.COMPONENT}-ami"
  }
}

resource "null_resource" "app-deploy" {
  triggers = {
    instance_ids = timestamp()
  }
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = local.SSH_USERNAME
      password = local.SSH_PASSWORD
      host     = aws_instance.ami.public_ip
    inline = [
      "ansible-pull -U https://github.com/vasanthi-dev/ansible.git roboshop-pull.yml -e COMPONENT=${var.COMPONENT} -e ENV=ENV -e APP_VERSION=${var.APP_VERSION} -e NEXUS_USERNAME=${local.NEXUS_USERNAME} -e NEXUS_PASSWORD=${local.NEXUS_PASSWORD}"
    ]
  }
}

