# This module will generate "iam_instance_profile.name", with the actions allowed for this IAM Role.
module "iam_instance_profile" {
    source = "terraform-in-action/iip/aws"

    # We are allowed to see all "logs" and "rds" data.
    # The permissions are too open for a production deployment, but good enough for dev.
    actions = ["logs:*", "rds:*"]
}

# This datasource creates the user data for our launch template.
data "cloudinit_config" "config" {
    gzip = true
    base64_encode = true
    part {
        content_type = "text/cloud-config"
        content = templatefile("${path.module}/cloud_config.yaml", var.db_config)
    }
}

data "aws_ami" "ubuntu" {
    most_recent = true
    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
    }
    owners = ["099720109477"]
}

# the template file that the autoScaling group will use to generate ec2 instances as needed.
resource "aws_launch_template" "webserver" {
    name_prefix = var.namespace
    image_id = data.aws_ami.ubuntu.id
    instance_type = "t2.micro"
    user_data = data.cloudinit_config.config.rendered
    key_name = var.ssh_keypair
    iam_instance_profile {
        name = module.iam_instance_profile.name
    }
    vpc_security_group_ids = [var.sg.websvr]
}

# configuring the autoScaling group, to be able to create the no of ec2 instances needed based on
# the aws_launch_template resource.
resource "aws_autoscaling_group" "webserver" {
    name = "${var.namespace}-asg"
    min_size = 1
    max_size = 3
    vpc_zone_identifier = var.vpc.private_subnets
    target_group_arns = module.alb.target_group_arns
    launch_template {
        id = aws_launch_template.webserver.id
        version = aws_launch_template.webserver.latest_version
    }
}

# aws alb module
module "alb" {
    source = "terraform-aws-modules/alb/aws"
    version = "~> 5.0"
    name = var.namespace
    load_balancer_type = "application"
    vpc_id = var.vpc.vpc_id
    subnets = var.vpc.public_subnets
    security_groups = [var.sg.lb]
    
    http_tcp_listeners = [{
        port = 80,
        protocol = "HTTP"
        target_group_index = 0
    }]

    target_groups = [{
        name_prefix = "websvr",
        backend_protocol = "HTTP",
        backend_port = 8080
        target_type = "instance"
    }]

}