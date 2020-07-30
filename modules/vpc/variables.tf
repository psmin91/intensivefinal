# VPC variable

variable "name" {
  description = "모듈에서 정의하는 모든 리소스 이름의 prefix"
  type        = string
}

variable "cidr" {
  description = "VPC에 할당한 CIDR block"
  type        = string
}

variable "public_subnets" {
  description = "Public Subnet IP 리스트"
  type        = list
}

variable "azs" {
  description = "사용할 availability zones 리스트"
  type        = list
}

variable "tags" {
  description = "모든 리소스에 추가되는 tag 맵"
  type        = map
}


#EC2 Variables

variable "alb_account_id" {
  description = "사용할 region의 alb account id"
  type        = string
  #https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/enable-access-logs.html
}

variable "amazon_linux" {
  # Amazon Linux AMI 2017.03.1 (HVM), SSD Volume Type - ami-4af5022c
  description = "사용할 region의 amazon linux 명"
  type        = string
}

variable "linux_instance_type" {
  # Amazon Linux AMI 2017.03.1 (HVM), SSD Volume Type - ami-4af5022c
  description = "linux instance type 명"
  type        = string
}

variable "keyname" {
  description = "keyname"
  type        = string
}

