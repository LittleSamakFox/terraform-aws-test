data "aws_security_group" "default" {
    name = "default"
}

resource "aws_instance" "k5s_instance_test1" {
    ami = "ami-033a6a056910d1137"
    instance_type = "t2.micro"
    key_name = aws_key_pair.k5s_key.key_name
    vpc_security_group_ids = [
        aws_security_group.k5s_security_group.id,
        data.aws_security_group.default.id
    ]
}