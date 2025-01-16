instance_type = "t3.small"
env          = "dev"
zone_id = "Z10377495CKDE7OXJB1E"

# vpc input
dev_vpc_cidr_block = "10.10.0.0/24"

default_vpc_id = "vpc-0d777bc0eeb02d730"
dev_route_table_id = "rtb-01dcc24591e0b7fe3"
default_rout_table_id = "rtb-0dfd6bd58ec8c4869"
default_vpc_cidr      = "172.31.0.0/16"
dev_vpc_cidr          = "10.10.0.0/24"

frontend_subnets   = ["10.10.0.0/27", "10.10.0.32/27"]
backend_subnets    = ["10.10.0.64/27", "10.10.0.96/27"]
db_subnets         = ["10.10.0.128/27", "10.10.0.160/27"]
public_subnets     = ["10.10.0.192/27", "10.10.0.224/27"]
Availability_zones = ["us-east-1a", "us-east-1b"]
certificate_arn    = "arn:aws:acm:us-east-1:471112569439:certificate/bd7ac27d-0328-41db-8128-ac7e9a5abed2"
bastion_nodes      = ["172.31.80.250/32"]
prometheus_nodes   = ["172.31.88.221/32"]
#server_app_port_sg_cidr =