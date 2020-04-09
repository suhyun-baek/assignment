###
# Author : bsh0817
# Created : 2020 04 04
# Updated : 2020 04 04
###

resource "aws_s3_bucket" "s3_state" {
        bucket = var.bucket_name
        acl    = "private"
        versioning {
                enabled = true
        }
        tags = var.tag_default
        lifecycle {
                prevent_destroy = true
        }
}