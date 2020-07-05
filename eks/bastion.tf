data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/*"]
    }
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
    owners = ["099720109477"]
}
resource "aws_key_pair" "clickit_key" {
  key_name = "clickit_key"
  public_key = file("../.ssh/clickit.pub")
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
        Name = "bastion-${var.namespace}-${var.environment}"
    }
}