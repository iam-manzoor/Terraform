# Terraform MetaArguments

### What is terraform meta arguments?
- Meta Arguments are provided by the TF to support arguments
- Using Meta Aruments we can implement certain logics without external scripts

#### depends_on
- By default TF executes the TF files in an alphabhatical order.
- In-case if you have single file with multiple resources TF doesnt know which recource to provision first.
- Implicit & Explict meta argument
- Explict uses `depends_on` We mention the dependency
```
resource "aws_s3_bucket" "my_bucket" {
  count = 2 #Hardcoded | Dynamic length(var.bucket_names)
  bucket = var.bucket_names[count.index]
  tags = var.tags
}

resource "aws_s3_bucket" "my_bucket2" {
  for_each = var.bucket_names_set
  bucket = each.value # each.key both are same
  tags = var.tags
  depends_on = [ aws_s3_bucket.my_bucket ] 
}

```
#### count
- Its not a function its a meat Argument
- it helps to count the values in a `list` `set` etc..
```
resource "aws_s3_bucket" "my_bucket" {
  count = 2 #Hardcoded | Dynamic length(var.bucket_names)
  bucket = var.bucket_names[count.index]
  tags = var.tags
}

variable "bucket_names {
  type = list(string)
  default = ["bucket1","bucket2"]
}
```
#### for_each
- iterator. Simillar to the `for loop`
- counters
```
resource "aws_s3_bucket" "my_bucket2" {
  for_each = var.bucket_names_set
  bucket = each.value # each.key both are same
  tags = var.tags
}

resource "aws_s3_bucket" "my_bucket2" {
  for_each = var.bucket_names_map
  bucket = each.value # each.value/each.key if use key you will get key if use value you will get value
  tags = var.tags
}

variable "bucket_names_set" {
  type = set(string)
  default = ["bucket3","bucket4"]
}

variable "bucket_name_map" {
  type = map(string)
  default = {
    name = "Manzoor"
    learn = "Terraform"
  }
}
```

#### Provider
- plugin. to download the necessary plugin

#### lifecycle


Is the file name always should be main.tf?
