resource "aws_instance" "instance" {
  ami           = data.aws_ami.ami.image_id
  instance_type = var.instance_type
  vpc_security_group_ids = [data.aws_security_group.selected.id]

  instance_market_options {
    market_type = "spot"
    spot_options {
      instance_interruption_behavior = "stop"
      spot_instance_type             = "persistent"
    }
  }

  tags = {
    Name    = var.component
    monitor = "yes"
    env     = var.env
  }
}
resource "null_resource" "ansible" {

    provisioner "remote-exec" {
      connection {
        type     = "ssh"
        user     =  jsondecode(data.vault_generic_secret.ssh.data_json).user
        password =  jsondecode(data.vault_generic_secret.ssh.data_json).pass
        host     = aws_instance.instance.public_ip
      }

      inline = [
      "sudo pip3.11 install ansible",
      "ansible-pull -i localhost, -U https://github.com/s-devops-i2/expense-ansible2.git -e role_name=${var.component} -e env=${var.env} expense-play.yml"

      ]
  }
}
resource "aws_route53_record" "dns_record" {
  name    = "${var.component}-${var.env}"
  type    = "A"
  zone_id = var.zone_id
  ttl     =  30
  records = [aws_instance.instance.private_ip]
}
