###
# Author : bsh0817
# Created : 2020 04 04
# Updated : 2020 04 04
###

variable "bucket_name" {
    default = "terraform-state.bsh0817"
}

variable "tag_default" {
	type 	= map(string)
	default = {
		"Author" = "bsh0817"
        "Created-at" = "2020-04-04"
	}
}
