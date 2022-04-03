#aws provider init
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws"  {
    region = "ap-northeast-2"
}

#pem key 가져와서 aws 키페어에 등록
resource "aws_key_pair" "k5s_key" {
    key_name = "goorm_project_k5s_public"
    public_key = file("~/.ssh/goorm_project_k5s_public.pem")
}

/*
#s3 버킷 for backend
resource "aws_s3_bucket" "k5_tfstate"{
    bucket = "k5s-tftate"
    versioning {
      enabled = true #tfstate file 삭제 방지
    }
}

#Terraform State Lock을 위한 DynamoDB 생성
resource "aws_dynamodb_table" "k5s_terraform_state_lock" {
  name           = "k5s-terraform-lock"
  hash_key       = "LockID"
  billing_mode   = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}
*/