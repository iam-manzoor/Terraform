# Type Constraints

#### Based on values
- Primitive
  - String
  - Number
  - BOOL
    ```
    Examples:
    Name: "Manzoor"
    full_name: "Manzoor Ahamed"
    age: 40
    is_adult: yes
    ```
```
variable "environment" {
  type = string
  default = "Dev"
  description = "For DEV environment"
}

variable "instance_count" {
  type = number
  default = 1
  description = "Provides instance count"
}

variable "monitoring" {
  type = bool
  default = true
}

variable "associate_public_ip" {
  type = bool
  default = false
}
```

- Complex
  - List
    ```
    variable "cidr_block" {
      type = list(string)
      default = ["1","2","3","4"]
    }
    variable "allowed_instance_type {
      type = list(string)
      default = ["t2.micro","t3.micro"]
    }
    ```
  - Set
  ```
    # **set** Duplicates are not allowed.
    # You can not access values using index when element is set
    # convert into list **tolist(var.allowed_instance_type)[0]**
    # set can have ony one data type
    variable "allowed_instance_type {
      type = set(string)
      default = ["t2.micro","t3.micro","t2.micro"]
    }
  ```
  - Map
  ```
  # Its a dictionary with key value
  # Access **tags = var.tags**
  # Other variables can also be accessed (eg environment). We cannot 
  variable "tags" {
    type = map(string)
    default = {
      Environment = "dev
      Name = dev-instance
      Created_By = "Terraform"
    }
  ```
  - Object
  ```
  # Can have multiple data types.
  # Access **var.config.region**
  variable "config" {
    type = object( {region = string, monitoring = bool, instance_count = number})
    default = {
      region = "us-east-1",
      monitoring = true,
      instance_count = 1
  }
  ```
  - Tuple
  ```
  # Can have multiple data types string, list, map etc..
  variable "ingress_values" {
    type = tuple([number,string,number])
    default = [ 443, "tcp", 443 ]
  }
  ```
- ANY
