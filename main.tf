data "aws_vpc" "vpc_id" {
  id = var.vpc.id
}
resource "aws_key_pair" "ubuntu" {
  key_name   = "ubuntu-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDPfbmXx4xboyRkaUbtKmJSBILKc4kcWiqcR6+GLHgi9c721SH8iMPcvsyrDvj6BJoo8VDIFRAiIa2mZNKsi2a5ZL9u5ro35yTuyEv8nyZwjXAZgO8sXtuols8OMeR8I0466wIFmFDUukQzXPOYiHHTcpIVJ9aMMXqZRj5j8mu5on+yrivWyQ3VmnyqxzWZEYhiBHM335hj05yTR5BHJpSWBr0iXlTsstkoOC6+skhwm6klBA5vGQ46YhMaXaeBpZH1QEeZOQAORpguvoAiFQ2Mj2Bc9mMzZPygbznZBMY+Y9jyL1hHIMz3KmCqBQkV/NaEVl8+Rw5DLFbPRc7eqC+vW9gpPIa5tNbnsHOdNBnc7zcWrRcHoh3fbyTRmbyC8wNVe2OLMTz3mmSFOSfEvyfs+KLutKeZxP/ANREBlCgxpohu07JWFhPSDX0QeLFd5F75NZe8G10En/KMyom07nzqBb6Ao9IKO+kXMgp+M87i7PI4EZntUkSztJ50rBQA4jM= tatoe@tatoe-pc"
}
resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "allow all"
  vpc_id      = data.aws_vpc.vpc_id.id

  ingress = [
    {
      description      = "Allow all"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      self             = false
      security_groups  = null
    }
  ]
  egress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "Allow all"
    from_port        = 0
    ipv6_cidr_blocks = null
    prefix_list_ids  = null
    protocol         = "-1"
    security_groups  = null
    self             = false
    to_port          = 0
  }]

}
resource "aws_instance" "testvm" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.ubuntu.key_name
  vpc_security_group_ids = [aws_security_group.allow_all.id]
  tags = {
    Name = "testvm"
  }
}
output "ec2_ip" {
  value = aws_instance.testvm.public_ip
}