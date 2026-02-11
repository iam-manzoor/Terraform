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
  - Set
  - Map
  - Object
  - Tuple
- ANY
