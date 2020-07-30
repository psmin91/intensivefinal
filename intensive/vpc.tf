provider "aws" {
    alias = "alpha-region"
    region = "us-west-2"
    }
/*
provider "aws" {
    alias = "beta-region"
    region = "ap-southeast-2"
    }   
*/

resource "aws_key_pair" "sshkey" {
    #cloud9 ssh-keygen 엔터4번 -> cat ~/.ssh/id_rsa.pub 값 활용

    key_name   = "user04-key"
    ##public_key = 
}

module "vpc-alpha" {
    source = "../modules/vpc"

    providers = {
        aws = aws.alpha-region
    }
    
    name = "user04"
    cidr = "4.0.0.0/16"
    azs              = ["us-west-2a", "us-west-2c"]
    public_subnets   = ["4.0.1.0/24", "4.0.2.0/24"]
    
    # us-west-2미국서부(오레곤)797873946194
    alb_account_id = "797873946194"
    # Amazon Linux AMI of us-west-2 ami-0bb5806b2e825a199
    amazon_linux = "ami-0bb5806b2e825a199"
    linux_instance_type = "t2.nano"
    keyname = aws_key_pair.sshkey.key_name
    
    tags = {
        Creater = "user04",
        "TerraformManaged" = "true"
  }
}


/*
module "vpc-beta" {
    source = "../modules/vpc"

    providers = {
        aws = aws.beta-region
    }
    
    name = "beta-10059"
    cidr = "11.15.0.0/16"
    azs              = ["ap-southeast-2a", "ap-southeast-2c"]
    public_subnets   = ["11.15.1.0/24", "11.15.2.0/24"]
    
    # ap-southeast-2	Asia Pacific (Sydney)	783225319266
    alb_account_id = "783225319266"
    # ap-southeast-2 : Amazon Linux AMI 2018.03.0 (HVM), SSD Volume Type - ami-020d764f9372da231
    amazon_linux = "ami-020d764f9372da231"
    linux_instance_type = "t2.nano"
    
    tags = {
        Creater = "10059",
        "TerraformManaged" = "true"
  }
}
*/