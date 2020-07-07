data "aws_ami" "ubuntu" {
    most_recent = true
    owners = ["099720109477"]

    filter {
      name = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
    }
}
resource "aws_key_pair" "clickit_key" {
  key_name = "clickit_key"
  public_key = file("../.ssh/authorized_keys")
}
resource "aws_eip" "bastion_ip" {
    vpc = true
    instance = aws_instance.bastion.id
}
resource "aws_instance" "bastion" {
    ami = data.aws_ami.ubuntu.id
    instance_type = "t2.micro"
    key_name = "clickit_key"

    tags = {
        Name = "bastion-${var.project_name}-${var.environment}"
    }
}