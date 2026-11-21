# Converts the file into a list of maps, where each map represents a row in the CSV file. 
#The keys of the map are the column headers, and the values are the corresponding values for that row. 


locals {
  users = csvdecode(file("${path.module}/users.csv"))
}