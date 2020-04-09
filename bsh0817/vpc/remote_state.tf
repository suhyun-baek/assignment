terraform {
  backend "s3" {
    bucket = "terraform-state.bsh0817"
    key    = "workspace/vpc/terraform.state"
    region = "ap-northeast-2"
    profile = "bsh0817"
  }
}
