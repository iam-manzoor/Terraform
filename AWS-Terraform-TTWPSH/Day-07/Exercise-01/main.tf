resource "aws_instance" "web_instance" {
    count = var.instance_count
    instance_type = var.allowed_vm_type[1]
    ami = "ami-0bfhsbr5y3imo0eb45"
    #region = tolist(var.allowed_region)[0]
    region = var.config.region

    monitoring = var.config.monitoring
    associate_public_ip_address = var.associate_public_IP
    tags = {
        Environment = var.environment
        Name = "${var.environment}-EC2-Instance" # String concatenation using local variable syntax
    }
}

resource "aws_security_group" "web_instance_sg" {
    name = "web_instance_sg"

    tags = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "allow_ipv4" {
    security_group_id = aws_security_group.web_instance_sg.id
    cidr_ipv4 = var.cidr_block[0]
    from_port = var.ingress_values[0]
    ip_protocol = var.ingress_values[1]
    to_port = var.ingress_values[2]
}

resource "aws_vpc_security_group_egress_rule" "allow_all_ipv4" {
    security_group_id = aws_security_group.web_instance_sg.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
}

resource "aws_security_group_rule" "allow_ingress_rule" {
    type = "ingress"
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = var.cidr_block
    security_group_id = aws_security_group.web_instance_sg.id
}




