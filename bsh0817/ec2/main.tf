###
# Author : bsh0817
# Created : 2020 04 04
# Updated : 2020 04 04
###

data "terraform_remote_state" "vpc" {
        backend = "s3"
        config = {
                bucket = var.aws_terraform_remote_state_bucket
                key    = "workspace/vpc/terraform.state"
                profile= var.aws_account
                region = var.aws_region
        }
}

resource "aws_key_pair" "project_key_pair" {
        key_name = "${var.project_env}-${var.project_name}-kp"
        public_key = file("${var.project_env}-${var.project_name}-kp.ppk")
        tags = merge(local.tag_default, {"Name" : "${var.project_env}-${var.project_name}-kp"})
}


# EC2 - security group
resource "aws_security_group" "alb_web_sg" {
	vpc_id = data.terraform_remote_state.vpc.outputs.aws_vpc_id
	name = "${var.project_env}-${var.project_name}-alb-web-sg"
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        ipv6_cidr_blocks = ["::/0"]
    }
	ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
	egress {
		from_port       = 0
		to_port         = 0
		protocol        = "-1"
		cidr_blocks     = ["0.0.0.0/0"]
	}
	tags = merge(local.tag_default, {"Name" : "${var.project_env}-${var.project_name}-web-sg"})
}

resource "aws_security_group" "ec2_web_sg" {
	vpc_id = data.terraform_remote_state.vpc.outputs.aws_vpc_id
	name = "${var.project_env}-${var.project_name}-ec2-web-sg"
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = [aws_security_group.alb_web_sg.id]
    }

	egress {
		from_port       = 0
		to_port         = 0
		protocol        = "-1"
		cidr_blocks     = ["0.0.0.0/0"]
	}
	tags = merge(local.tag_default, {"Name" : "${var.project_env}-${var.project_name}-web-sg"})
}



# EC2 - instance
resource "aws_instance" "project_ec2_web_01" {
	ami = "ami-020934aa2a26c2c00"
	instance_type = "t2.micro"
	subnet_id = data.terraform_remote_state.vpc.outputs.private_web_01
	key_name = aws_key_pair.project_key_pair.key_name
	vpc_security_group_ids =[aws_security_group.ec2_web_sg.id] 
	tags = merge(local.tag_default, {"Name" : "${var.project_env}-${var.project_name}-ec2-web-01"})
}

resource "aws_instance" "project_ec2_web_02" {
	ami = "ami-020934aa2a26c2c00"
	instance_type = "t2.micro"
	subnet_id = data.terraform_remote_state.vpc.outputs.private_web_02
	key_name = aws_key_pair.project_key_pair.key_name
	vpc_security_group_ids =[aws_security_group.ec2_web_sg.id] 
	tags = merge(local.tag_default, {"Name" : "${var.project_env}-${var.project_name}-ec2-web-02"})
}

# EC2 - lb target group
resource "aws_lb_target_group" "ec2_target_01" {
	name = "${var.project_env}-${var.project_name}-ec2-web-01"
	port = 80
	protocol = "HTTP"
	vpc_id = data.terraform_remote_state.vpc.outputs.aws_vpc_id
	
}

resource "aws_lb_target_group_attachment" "solution_tg_ec2_web_01" {
	target_group_arn = aws_lb_target_group.ec2_target_01.arn
	target_id = aws_instance.project_ec2_web_01.id
	port = 80
}

resource "aws_lb_target_group_attachment" "solution_tg_ec2_web_02" {
	target_group_arn = aws_lb_target_group.ec2_target_01.arn
	target_id = aws_instance.project_ec2_web_02.id
	port = 80
}

# EC2 - lb 
resource "aws_lb" "project_lb_web_01" {
	name               = "${var.project_env}-${var.project_name}-alb-web-01" 
	internal           = false
	load_balancer_type = "application"
	security_groups    = [aws_security_group.alb_web_sg.id]
	subnets            = [data.terraform_remote_state.vpc.outputs.public_dmz_01, data.terraform_remote_state.vpc.outputs.public_dmz_02]
	enable_deletion_protection = false
	tags = merge(local.tag_default, {"Name" : "${var.project_env}-${var.project_name}-alb-web-01"})
}

resource "aws_lb_listener" "project_lb_listener_web" {
	load_balancer_arn = aws_lb.project_lb_web_01.arn
	port              = "80"
	protocol          = "HTTP"
	default_action {
		type             = "forward"
		target_group_arn = aws_lb_target_group.ec2_target_01.arn
	}
}
