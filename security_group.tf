#보안 그룹 설정
resource "aws_security_group" "k5s_security_group" {
    //vpc_id = "${moudle.vpc.vpc_id}" # 생성할 VPC ID
    name = "allow_ssh_HTTP_ping_from_all"
    description = "allow_ssh_HTTP_ping_from_all"
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
}