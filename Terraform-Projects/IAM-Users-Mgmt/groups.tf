resource "aws_iam_group" "Engineering" {
  name = "engineering"
  path = "/groups"
}

resource "aws_iam_group" "Marketing" {
  name = "marketing"
  path = "/groups"
}

resource "aws_iam_group" "Human_Resources" {
  name = "humanresources"
  path = "/groups"
}

resource "aws_iam_group" "Operations" {
  name = "operations"
  path = "/groups"
}


resource "aws_iam_group_membership" "Engineering_members" {
  name = "engineering-group-membership"
  group = aws_iam_group.Engineering.name
  users = [
    for user in aws_iam_user.users: user.name if user.tags.Department == "Engineering"
  ]
}

resource "aws_iam_group_membership" "Marketing_members" {
  name = "marketing-group-membership"
  group = aws_iam_group.Marketing.name

  users = [
    for user in aws_iam_user.users: user.name if user.tags.Department == "Marketing"
  ]
}

resource "aws_iam_group_membership" "operations_members" {
  name = "operation-group-membership"
  group = aws_iam_group.Operations.name

  users = [
    for user in aws_iam_user.users: user.name if user.tags.Department == "Operations"
  ]
}

resource "aws_iam_group_membership" "managers_members" {
  name  = "managers-group-membership"
  group = aws_iam_group.managers.name

  users = [
    for user in aws_iam_user.users : user.name if contains(keys(user.tags), "job_title") && can(regex("Manager|CEO", user.tags.job_titleitle))
  ]
}