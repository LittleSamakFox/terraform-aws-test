#pem key 가져와서 aws 키페어에 등록
resource "aws_key_pair" "k5s_admin" {
    key_name = "k5s_admin"
    public_key = file("~/.ssh/goorm_project_k5s.pem")
}