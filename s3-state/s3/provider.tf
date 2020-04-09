###
# Author : bsh0817
# Created : 2020 04 04
# Updated : 2020 04 04
###

provider "aws" {
    region = "ap-northeast-2"
    shared_credentials_file = "/home/ubuntu/.aws/credentials"
    profile                 = "bsh0817"
}