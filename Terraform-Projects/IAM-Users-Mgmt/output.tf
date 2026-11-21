output "account_id" {
  value = data.aws_caller_identity.current.id
}

# Loop through the local variable users
output "user_name" {
  value = [for user in local.users: "${user.first_name} ${user.last_name}"]
}

output "user_password" {
  value = {
    for user,profile in aws_iam_user_login_profile.login:
    user => "password crested - user must rest on first login"
  }

  sensitive = true
}