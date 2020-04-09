output "aws_vpc_id" {
  value = aws_vpc.project_vpc.id
}

output "public_dmz_01" {
  value = aws_subnet.public_dmz_01.id
}

output "public_dmz_02" {
  value = aws_subnet.public_dmz_02.id
}

output "private_web_01" {
  value = aws_subnet.private_web_01.id
}

output "private_web_02" {
  value = aws_subnet.private_web_02.id
}

output "private_was_01" {
  value = aws_subnet.private_was_01.id
}

output "private_was_02" {
  value = aws_subnet.private_was_02.id
}

output "private_db_01" {
  value = aws_subnet.private_db_01.id
}

output "private_db_02" {
  value = aws_subnet.private_db_02.id
}
