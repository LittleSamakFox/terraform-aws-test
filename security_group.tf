#VPC Default SecurityGroup
resource "aws_default_security_group" "k5s_vpc_sg_default"{
    vpc_id = aws_vpc.k5s_vpc.id
    ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
    }
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }
}

#EC2보안 그룹 설정
resource "aws_security_group" "k5s_sg_bastion" {
    vpc_id = aws_vpc.k5s_vpc.id
    name = "k5s_sg_bastion"
    description = "Security group for bastion instance"
    ingress { //SSH
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress { //HTTP
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks =  ["0.0.0.0/0"]
    }
    ingress { //HTTPS
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks =  ["0.0.0.0/0"]
    }
    ingress { //ICMP
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks =  ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      "Name" = "${var.aws_default_name}-Bastion-SG"
    }
}