# To get the random genrated passwrod of our DB from the DB module and be able to see it in the CLI.
output "db_password" {
  value = module.database.db_config.password
  sensitive = true
}

output "lb_dns_name" {
    value = module.autoscaling.lb_dns_name
}