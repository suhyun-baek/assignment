terraform {
  backend "s3" {
    bucket = "terraform-state.bsh0817"
    key    = "workspace/ec2/terraform.state"
    region = "ap-northeast-2"
    profile = "bsh0817"
  }
}
