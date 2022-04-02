resource "aws_ami_from_instance" "example" {
  name               = "${var.COMPONENT}-${var.APP_VERSION}"
  source_instance_id = aws_instance.ami.id
  tags = {
    Name = "${var.COMPONENT}-${var.APP_VERSION}"
  }
}