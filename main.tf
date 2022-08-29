module "image" {
    
  source = "github.com/jojojoseff/moduleami.git"

}

########KEYPAIR##########
resource "aws_key_pair" "localkey" {
  key_name   = "${var.project}-${var.env}"
  public_key = file("localkey.pub")
  tags = {
    Name = "${var.project}-${var.env}"
    project = var.project
    env = var.env
  }
}

########Security_Groups##########
resource "aws_security_group" "ssh" {
  name_prefix        = "something-${var.project}-${var.env}"
  description = "Allow ssh-some inbound traffic"

  ingress {

    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "something-${var.project}-${var.env}"
    project = var.project
    env = var.env
  }
}

resource "aws_security_group" "web" {
  name_prefix = "web-${var.project}-${var.env}"
  description = "Asssllow ssh-some inbound traffic"

  ingress {

    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {

    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "web-${var.project}-${var.env}"
    project = var.project
    env = var.env
  }
}





########INSTANCE##########
resource "aws_instance" "frontend" {
  ami           = module.image.latestami
  instance_type = var.instance_type
  vpc_security_group_ids = [ "sg-0158953d9b293d18d" ]
  key_name = aws_key_pair.localkey.key_name
  tags = {
    Name = "${var.project}-${var.env}dev2"
    project = var.project
    env = var.env
  }
}

