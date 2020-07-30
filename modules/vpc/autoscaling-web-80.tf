resource "aws_security_group" "public-web-sg-80" {

    description = "Allow HTTP/ssh inbound connections"
    vpc_id = aws_vpc.this.id
    
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    tags = merge(var.tags, map("Name", format("%s-WEB-SG-80", var.name)))
}

# Create Configuration for auto-scale group
resource "aws_launch_configuration" "web-ac-80" {
    name_prefix = "${var.name}-ac-web-80-"
    
    image_id = var.amazon_linux
    instance_type = var.linux_instance_type
    key_name = var.keyname
    security_groups = [
        aws_security_group.public-web-sg-80.id,
        aws_default_security_group.default-sg.id
    ]
    associate_public_ip_address = true
    
    ####iam_role.tf####
    iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
    ###################
    
    ##서버 들어가서 입력되는 값##
    user_data = <<USER_DATA
    #!/bin/bash
    yum -y update
    yum -y install ruby
    yum -y install wget
    wget -P /home/ec2-user/ https://aws-codedeploy-us-east-2.s3.amazonaws.com/latest/codedeploy-agent.noarch.rpm
    yum -y install /home/ec2-user/codedeploy-agent.noarch.rpm
    service codedeploy-agent start
    USER_DATA
    
    lifecycle {
        create_before_destroy = true
    }
}


# Create auto-scale group
resource "aws_autoscaling_group" "web-ac-group-80" {
    name = "${aws_launch_configuration.web-ac-80.name}-asg"
    
    min_size = 1
    desired_capacity = 2
    max_size = 3
    
    health_check_type = "ELB"
    #load_balancers= ["${aws_alb.alb.id}" ] #classic
    target_group_arns = [aws_alb_target_group.alb-tg-80.arn]
    #alb = "${aws_alb.alb.id}"
    
    launch_configuration = aws_launch_configuration.web-ac-80.name
    #### availability_zones = ["ap-southeast-1a", "ap-southeast-1b"] 아래 vpc_zone_identifier 와 중복
    
    enabled_metrics = [
        "GroupMinSize",
        "GroupMaxSize",
        "GroupDesiredCapacity",
        "GroupInServiceInstances",
        "GroupTotalInstances"
    ]
    
    metrics_granularity= "1Minute"
    
    vpc_zone_identifier = aws_subnet.public.*.id
    
    # Required to redeploy without an outage.
    lifecycle {
        create_before_destroy = true
    }
    tag {
        key                 = "Name"
        value               = "${var.name}-region1-web-autoscaling"
        propagate_at_launch = true
    }
}

resource "aws_autoscaling_attachment" "web-ac-attachment-80" {
    autoscaling_group_name = aws_autoscaling_group.web-ac-group-80.id
    alb_target_group_arn = aws_alb_target_group.alb-tg-80.arn
}

######################################################################
######################### Auto Scaling Policy ########################
# Create Autoscale up Policy
resource "aws_autoscaling_policy" "web_policy_up-80" {
    name = "${aws_autoscaling_group.web-ac-group-80.name}-web_policy_up-80"
    scaling_adjustment = 1
    adjustment_type = "ChangeInCapacity"
    cooldown = 10
    autoscaling_group_name = aws_autoscaling_group.web-ac-group-80.name
}

resource "aws_cloudwatch_metric_alarm" "web_policy_cpu_alarm_up-80" {
    alarm_name = "${aws_autoscaling_group.web-ac-group-80.name}-web_policy_cpu_alarm_up-80"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods = "2"
    metric_name = "CPUUtilization"
    namespace = "AWS/EC2"
    period = "120"
    statistic = "Average"
    threshold = "20"
    
    #dimensions {
    # AutoScalingGroupName = "${aws_autoscaling_group.web.name}"
    #}
    
    alarm_description = "This metric monitor EC2 instance CPU utilization"
    alarm_actions = [aws_autoscaling_policy.web_policy_up-80.arn]
}


# Create AutoScale down policy
resource "aws_autoscaling_policy" "web_policy_down-80" {
    name = "${aws_autoscaling_group.web-ac-group-80.name}-web_policy_down-80"
    scaling_adjustment = -1
    adjustment_type = "ChangeInCapacity"
    cooldown = 10
    autoscaling_group_name = aws_autoscaling_group.web-ac-group-80.name
}

resource "aws_cloudwatch_metric_alarm" "user16_region1_web1_cpu_alarm_down-80" {
    alarm_name = "${aws_autoscaling_group.web-ac-group-80.name}-web_policy_cpu_alarm_down-80"
    comparison_operator = "LessThanOrEqualToThreshold"
    evaluation_periods = "2"
    metric_name = "CPUUtilization"
    namespace = "AWS/EC2"
    period = "120"
    statistic = "Average"
    threshold = "10"
    
    #dimensions {
    # AutoScalingGroupName = "${aws_autoscaling_group.web.name}"
    #:}
    
    alarm_description = "This metric monitor EC2 instance CPU utilization"
    alarm_actions = [aws_autoscaling_policy.web_policy_down-80.arn]
}