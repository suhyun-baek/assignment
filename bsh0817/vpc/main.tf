###
# Author : bsh0817
# Created : 2020 04 04
# Updated : 2020 04 04
###

# vpc - vpc
resource "aws_vpc" "project_vpc" {
	cidr_block = "${var.pre_cidr_block}0.0/16"
	enable_dns_hostnames = true
	enable_dns_support = true
	instance_tenancy = "default"
	tags = merge(local.tag_default, {"Name" = "${var.project_env}-${var.project_name}-vpc"})
}

# vpc - subnet
resource "aws_subnet" "public_dmz_01" {
	vpc_id = aws_vpc.project_vpc.id
	cidr_block = "${var.pre_cidr_block}0.0/24"
    availability_zone = var.availability_zone_01
    map_public_ip_on_launch = true
    tags = merge(local.tag_default, {"Name" = "${var.project_env}-${var.project_name}-dmz-01.internal.${var.availability_zone_01}"})
}

resource "aws_subnet" "public_dmz_02" {
	vpc_id = aws_vpc.project_vpc.id
	cidr_block = "${var.pre_cidr_block}1.0/24"
    availability_zone = var.availability_zone_02
    map_public_ip_on_launch = true
    tags = merge(local.tag_default, {"Name" = "${var.project_env}-${var.project_name}-dmz-02.internal.${var.availability_zone_02}"})
}

resource "aws_subnet" "private_web_01" {
	vpc_id = aws_vpc.project_vpc.id
	cidr_block = "${var.pre_cidr_block}2.0/24"
    availability_zone = var.availability_zone_01
    map_public_ip_on_launch = true
    tags = merge(local.tag_default, {"Name" = "${var.project_env}-${var.project_name}-web-01.internal.${var.availability_zone_01}"})
}

resource "aws_subnet" "private_web_02" {
	vpc_id = aws_vpc.project_vpc.id
	cidr_block = "${var.pre_cidr_block}3.0/24"
    availability_zone = var.availability_zone_02
    map_public_ip_on_launch = true
    tags = merge(local.tag_default, {"Name" = "${var.project_env}-${var.project_name}-web-02.internal.${var.availability_zone_02}"})
}

resource "aws_subnet" "private_was_01" {
	vpc_id = aws_vpc.project_vpc.id
	cidr_block = "${var.pre_cidr_block}4.0/24"
    availability_zone = var.availability_zone_01
    map_public_ip_on_launch = true
    tags = merge(local.tag_default, {"Name" = "${var.project_env}-${var.project_name}-was-01.internal.${var.availability_zone_01}"})
}

resource "aws_subnet" "private_was_02" {
	vpc_id = aws_vpc.project_vpc.id
	cidr_block = "${var.pre_cidr_block}5.0/24"
    availability_zone = var.availability_zone_02
    map_public_ip_on_launch = true
    tags = merge(local.tag_default, {"Name" = "${var.project_env}-${var.project_name}-was-02.internal.${var.availability_zone_02}"})
}

resource "aws_subnet" "private_db_01" {
	vpc_id = aws_vpc.project_vpc.id
	cidr_block = "${var.pre_cidr_block}6.0/24"
    availability_zone = var.availability_zone_01
    map_public_ip_on_launch = true
    tags = merge(local.tag_default, {"Name" = "${var.project_env}-${var.project_name}-db-01.internal.${var.availability_zone_01}"})
}

resource "aws_subnet" "private_db_02" {
	vpc_id = aws_vpc.project_vpc.id
	cidr_block = "${var.pre_cidr_block}7.0/24"
    availability_zone = var.availability_zone_02
    map_public_ip_on_launch = true
    tags = merge(local.tag_default, {"Name" = "${var.project_env}-${var.project_name}-db-02.internal.${var.availability_zone_02}"})
}


# vpc - internet gateway
resource "aws_internet_gateway" "project_vpc_ig" {
	vpc_id = aws_vpc.project_vpc.id
	tags = merge(local.tag_default, {"Name" = "${var.project_env}-${var.project_name}-ig"})
}

# vpc - route table
resource "aws_route_table" "project_vpc_rt_public_01"{
        vpc_id = aws_vpc.project_vpc.id
        route {
                cidr_block = "0.0.0.0/0"
                gateway_id = aws_internet_gateway.project_vpc_ig.id
        }
        tags = merge(local.tag_default, {"Name" : "${var.project_env}-${var.project_name}-rt-public-01"})

}
resource "aws_route_table_association" "project_vpc_rt_public_as_01" {
        subnet_id = aws_subnet.public_dmz_01.id
        route_table_id = aws_route_table.project_vpc_rt_public_01.id

}
resource "aws_route_table_association" "project_vpc_rt_public_as_02" {
        subnet_id = aws_subnet.public_dmz_02.id
        route_table_id = aws_route_table.project_vpc_rt_public_01.id
}



# vpc - nat gateway ip
resource "aws_eip" "project_eip_natgateway_01" {
	vpc = true
}

resource "aws_eip" "project_eip_natgateway_02" {
	vpc = true
}

# vpc - nat gateway 
resource "aws_nat_gateway" "project_natgateway_01" {
	allocation_id = aws_eip.project_eip_natgateway_01.id
	subnet_id = aws_subnet.public_dmz_01.id
	tags = merge(local.tag_default, {"Name" : "${var.project_env}-${var.project_name}-ng-01"})
}


resource "aws_nat_gateway" "project_natgateway_02" {
	allocation_id = aws_eip.project_eip_natgateway_02.id
	subnet_id = aws_subnet.public_dmz_02.id
	tags = merge(local.tag_default, {"Name" : "${var.project_env}-${var.project_name}-ng-02"})
}


# vpc - route table
resource "aws_route_table" "project_vpc_rt_private_01"{
	vpc_id = aws_vpc.project_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.project_natgateway_01.id
    }
	tags = merge(local.tag_default, {"Name" : "${var.project_env}-${var.project_name}-rt-private-01"})

}

resource "aws_route_table_association" "project_vpc_rt_private_as_01_01" {
	subnet_id = aws_subnet.private_web_01.id
	route_table_id = aws_route_table.project_vpc_rt_private_01.id
}

resource "aws_route_table_association" "project_vpc_rt_private_as_01_02" {
        subnet_id = aws_subnet.private_was_01.id
        route_table_id = aws_route_table.project_vpc_rt_private_01.id
}

resource "aws_route_table_association" "project_vpc_rt_private_as_01_03" {
        subnet_id = aws_subnet.private_db_01.id
        route_table_id = aws_route_table.project_vpc_rt_private_01.id
}

resource "aws_route_table" "project_vpc_rt_private_02"{
	vpc_id = aws_vpc.project_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.project_natgateway_02.id
    }
	tags = merge(local.tag_default, {"Name" : "${var.project_env}-${var.project_name}-rt-private-02"})

}

resource "aws_route_table_association" "project_vpc_rt_private_as_02_01" {
	subnet_id = aws_subnet.private_web_02.id
	route_table_id = aws_route_table.project_vpc_rt_private_02.id
}

resource "aws_route_table_association" "project_vpc_rt_private_as_02_02" {
        subnet_id = aws_subnet.private_was_02.id
        route_table_id = aws_route_table.project_vpc_rt_private_02.id
}

resource "aws_route_table_association" "project_vpc_rt_private_as_02_03" {
        subnet_id = aws_subnet.private_db_02.id
        route_table_id = aws_route_table.project_vpc_rt_private_02.id
}
