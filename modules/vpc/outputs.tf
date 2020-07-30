output "vpc_id" {
  description = "VPC ID"
  value       = "${aws_vpc.this.id}"
}

output "vpc_cidr_block" {
  description = "VPC에 할당한 CIDR block"
  value       = "${aws_vpc.this.cidr_block}"
}

output "default_security_group_id" {
  description = "VPC default Security Group ID"
  value       = "${aws_vpc.this.default_security_group_id}"
}

# internet gateway
output "igw_id" {
  description = "Interget Gateway ID"
  value       = "${aws_internet_gateway.this.id}"
}


output "public_subnets_ids" {
  description = "Public Subnet ID 리스트"
  value       = ["${aws_subnet.public.*.id}"]
}

# route tables
output "public_route_table_ids" {
  description = "Public Route Table ID 리스트"
  value       = ["${aws_route_table.public.*.id}"]
}
