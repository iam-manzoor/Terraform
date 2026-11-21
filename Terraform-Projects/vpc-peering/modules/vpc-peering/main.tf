resource "aws_vpc_peering_connection" "vpc_peering_connection" {
  vpc_id        = var.requester_vpc_id
  peer_vpc_id   = var.accepter_vpc_id
  auto_accept   = true

  tags = {
    Name = "VPC Peering Connection"
  } 
}

# Add routes of the requester to the routes of accepter route tables
resource "aws_route" "requester_routes" {
    count = length(var.requester_route_table_ids)
    route_table_id         = var.requester_route_table_ids[count.index]
    destination_cidr_block = var.accepter_vpc_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering_connection.id
}

# Add routes of the accepter to the routes of requester route tables
resource "aws_route" "accepter_routes" {
    count = length(var.accepter_route_table_ids)
    route_table_id         = var.accepter_route_table_ids[count.index]
    destination_cidr_block = var.requester_vpc_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering_connection.id
}