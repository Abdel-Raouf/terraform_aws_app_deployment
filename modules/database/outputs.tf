# All the data in "db_config" comes from select output of the "aws_db_instance" resource.
# Exposing the Minumum needed configuration for the Autoscaling module to be able to function well.   
output "db_config" {
  value = {
    user        = aws_db_instance.database.username
    password    = aws_db_instance.database.password
    database    = aws_db_instance.database.name
    hostname    = aws_db_instance.database.address
    port        = aws_db_instance.database.port
  }
}