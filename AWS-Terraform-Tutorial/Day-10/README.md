# Terraform Expressions

### Conditional Expressions
- `True` OR `FALSE`
` condition ? true_value : false_value`
- Example `var.env == dev ? var.instance_type == "t2.micro" : var.instance_type == "t3.micro"`


### Dynamic Blocks for something like ingress_riles
```
variable "ingress_rule" {
    type = list(object({
        from_port = number
        to_port = number
        protocol = string
        cidr_blocks = list(string)
        description = string
    }))
    default = [
      {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "HTTP"
      },
      {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "HTTPS"
      }
    ]
}
```

### Splat Expression
- List of variable with all instance type
```
locals {
    all_instance_ids = aws_instance.conditional_instance[*].id
}
```