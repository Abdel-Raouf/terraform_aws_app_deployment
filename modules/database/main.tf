# Generate a random password to our DB, which we will know when making "terraform apply"
# by exposing it from here as an output in the root module.
resource "random_password" "password" {
    length                  = 16
    special                 = true
    override_special        = "_%@/'\""
}

# To pass values between modules use "var" keyword, then what we need as ${var.namespace}
# We get our db_subnet_group_name from the vpc in our custom networking module.
resource "aws_db_instance" "database" {
    allocated_storage       = 10
    engine                  = "mysql"
    engine_version          = "8.0"
    instance_class          = "db.t2.micro"
    identifier              = "${var.namespace}-db-instance"
    name                    = "pets"
    username                = "admin"
    password                = random_password.password.result
    db_subnet_group_name    = var.vpc.database_subnet_group
    vpc_security_group_ids  = [var.sg.db]
    skip_final_snapshot     = true
}

