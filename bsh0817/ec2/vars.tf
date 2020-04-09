#common
variable "aws_account" {
    default = "bsh0817"
}
variable "aws_region" {
    default = "ap-northeast-2"
}

variable "aws_credentials_file_path" {
    default = "/home/ubuntu/.aws/credentials"
}

variable "aws_terraform_remote_state_bucket" {
    default = "terraform-state.bsh0817"
}

variable "project_env" {
    default = "prod"
}

variable "project_name" {
	default = "bsh0817"
}

locals {
	tag_default = {
		"Author" = "bsh0817"
        "Created-at" = "2020-04-04"
	}
}
