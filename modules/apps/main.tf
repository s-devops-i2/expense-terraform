resource "aws_security_group" "main" {
  name        = "${var.component}-${var.env}-sg"
  description = "${var.component}-${var.env}-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  tags = {
    Name = "${var.component}-${var.env}-sg"
  }
}

resource "aws_instance" "instance" {
  ami                    = data.aws_ami.ami.image_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.main.id]
  subnet_id              =  var.subnets[0]

   tags = {
    Name    = var.component
    monitor = "yes"
    env     = var.env

  }
  lifecycle {
   ignore_changes        = [ami]
  }

}
resource "null_resource" "ansible" {
  connection {
    type     = "ssh"
    user     =  jsondecode(data.vault_generic_secret.ssh.data_json).ansible_user
    password =  jsondecode(data.vault_generic_secret.ssh.data_json).ansible_password
    host     = aws_instance.instance.private_ip
  }
    provisioner "remote-exec" {
      inline = [
        "sudo pip3.11 install ansible hvac",
        "rm -f ~/secrets.json ~/app.json",
        "ansible-pull -i localhost, -U https://github.com/s-devops-i2/expense-ansible2.git get-secrets.yml -e env=${var.env} -e role_name=${var.component} -e vault_token=${var.vault_token}",
        "ansible-pull -i localhost, -U https://github.com/s-devops-i2/expense-ansible2.git expense-play.yml -e env=${var.env} -e role_name=${var.component} -e @~/secrets.json -e @~/app.json"
      ]
  }
  provisioner "remote-exec" {
     inline = [
        "rm -f ~/secrets.json ~/app.json"
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

resource "aws_lb" "main" {
  count              = var.lb_needed ? 1 : 0
  name               = "${var.env}-${var.component}-lb"
  internal           = var.lb_type == "public " ? false : true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.main.id]
  subnets            = var.lb_subnet

  tags = {
    Environment = "${var.env}-${var.component}-lb"
  }
}

resource "aws_lb_target_group" "lb-tg" {
  count                = var.lb_needed ? 1 : 0
  name                 = "${var.env}-${var.component}-tg"
  port                 = var.lb_port
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  deregistration_delay = 15

  health_check {
    healthy_threshold   = 2
    interval            = 5
    path                = "/health"
    port                = var.lb_port
    timeout             = 2
    unhealthy_threshold = 2

  }
}

resource "aws_lb_target_group_attachment" "tg-attachment" {
  count            = var.lb_needed ? 1 : 0
  target_group_arn = aws_lb_target_group.lb-tg[0].arn
  target_id        = aws_instance.instance.id
  port             = var.lb_port
}

resource "aws_lb_listener" "listener" {
  count            = var.lb_needed ? 1 : 0
  load_balancer_arn = aws_lb.main[0].arn
  port              = var.lb_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb-tg[0].arn
  }
}