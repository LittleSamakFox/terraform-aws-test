#IAM 유저 생성
resource "aws_iam_user" "k5s_user1" {
  name = "eevvee"
}
#IAM 그룹 생성
resource "aws_iam_group" "k5s_group" {
  name = "pokemon"
}
#IAM 그룹에 IAM 유저 등록
resource "aws_iam_group_membership" "pokemon" {
  name = aws_iam_group.k5s_group.name
  users = [
    aws_iam_user.k5s_user1.name
  ]
  group = aws_iam_group.k5s_group.name
}

#IAM User Policy 생성
#아래는 유저가 모든 권한 가지게 설정한 것
resource "aws_iam_user_policy" "k5s_iam_user_policy" {
    name = "evolution_stone"
    user = aws_iam_user.k5s_user1.name

    policy =  <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "*"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}


#IAM role 생성
resource "aws_iam_role" "k5s_iam_role" {
    name = "k5s_iam_role"
    path = "/"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
resource "aws_iam_role_policy" "k5s_iam_role_policy" {
  name   = "k5s_iam_role_policy_s3"
  role   = aws_iam_role.k5s_iam_role.id
  policy = <<EOF
{
  "Statement": [
    {
      "Sid": "AllowAppArtifactsReadAccess",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": [
        "*"
      ],
      "Effect": "Allow"
    }
  ]
}
EOF
}
#IAM 역할을 위한 컨테이너, 인스턴스 시작시 EC2 인스턴스에 역할 정보 전달
resource "aws_iam_instance_profile" "k5s_iam_instance_profile" {
  name = "k5s_iam_instance_profile"
  role = aws_iam_role.k5s_iam_role.name
}