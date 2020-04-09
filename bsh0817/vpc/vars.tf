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

variable "aws_service_name" {
    default = "vpc"
}

variable "project_env" {
    default = "prod"
}

variable "project_name" {
	default = "bsh0817"
}

variable "availability_zone_01" {
	default = "ap-northeast-2a"
}

variable "availability_zone_02" {
	default = "ap-northeast-2c"
}



locals {
	tag_default = {
        "Author" = "bsh0817"
        "Created-at" = "2020-04-04"
	}
}


variable "pre_cidr_block" {
	default = "192.168."
}
