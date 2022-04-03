/*
terraform {
  backend "s3" {
      bucket         = "k5s-tftate"  #버킷이름
      key            = "terraform/k5s/terraform.tfstate"
      region         = "ap-northeast-2"
      encrypt        = true
      dynamodb_table = "k5s_terraform_lock" #생성한 DyanmoDB 이름
  }
}
*/