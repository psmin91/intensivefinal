
# alb for http ( 80, 8080 ) required S3, alb SG
resource "aws_alb" "public" {
    name = "${var.name}-public-ALB"
    internal = false
    security_groups = [aws_security_group.alb-sg.id]
    subnets = aws_subnet.public.*.id
    access_logs {
        bucket = aws_s3_bucket.alb-s3.id
        prefix = "${var.name}-frontend-alb"
        enabled = true
    }
    
    lifecycle { create_before_destroy = true }
    
    tags = merge(var.tags, map("Name", format("%s-public-ALB", var.name)))
    
}

# security group for alb , alb SG
resource "aws_security_group" "alb-sg" {
    description = "Allow HTTP inbound connections"
    vpc_id = aws_vpc.this.id

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    /*
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    */
    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    tags = merge(var.tags, map("Name", format("%s-public-ALB-SG", var.name)))
}

# Create S3 for alb logging
resource "aws_s3_bucket" "alb-s3" {

    bucket = "${var.name}-alb-log.com"
    #acl = "public-read-write"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.alb_account_id}:root"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${var.name}-alb-log.com/*"
    }
  ]
}
  EOF

    lifecycle_rule {
        id      = "log_lifecycle"
        prefix  = ""
        enabled = true

        transition {
        days          = 30
        storage_class = "GLACIER"
        }

        expiration {
        days = 90
        }
    }

    lifecycle {
        prevent_destroy = false
    }
}
############# Port 80 ##################
resource "aws_alb_target_group" "alb-tg-80" { 
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.this.id
    
    health_check {
        interval = 30
        path = "/"
        healthy_threshold = 3
        unhealthy_threshold = 3
    }
    
    tags = merge(var.tags, map("Name", format("%s-public-ALB-TG-80", var.name)))
}

resource "aws_alb_listener" "alb-listener-80" {
    load_balancer_arn = aws_alb.public.arn
    port = "80"
    protocol = "HTTP"
    default_action {
        target_group_arn = aws_alb_target_group.alb-tg-80.arn
        type = "forward"
    }
}



