#s3 버킷 for backend
resource "aws_s3_bucket" "k5s_s3bucket"{
    bucket = "k5s-storage"
    tags = {
        Name = "k5s_storage"
    }
}