### OUTPUT variable
#output "name" {
#    value = aws_vpc.sample.id
#}

#output "ec2_id" {
#    value = aws_instance.web_instance.id
#}

Splat operator to get all the instance ids when count is used
output "instance_id" {
    value = aws_instance.conditional_instance.*.id
}