resource "aws_instance" "instance" {
  ami           = data.aws_ami.ami.image_id
  instance_type = var.instance_type
  vpc_security_group_ids = [data.aws_security_group.selected.id]

  tags = {
    Name = var.component
  }
}
resource "null_resource" "ansible" {

    provisioner "remote-exec" {
      connection {
        type     = "ssh"
        user     = var.ssh_user
        password = var.ssh_password
        host     = aws_instance.instance.public_ip
      }

      inline = [
      "echo connected..to..remote..host"
    ]
  }

}
