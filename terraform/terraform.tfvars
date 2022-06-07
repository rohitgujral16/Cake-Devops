eks_role = "eks_cake_role"
eks_name = "cake_test"

vpc_name = "cake_vpc"
vpc_cidr = "10.0.0.0/16"
private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
public_subnets = ["10.0.3.0/24", "10.0.4.0/24"]

### Aurora variables ####
aurora_name = "cake-postgres"
db_name = "cake_db"
db_port = "5432"
db_password = "test123"
db_user = "test"
