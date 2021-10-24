# A child module can use outputs to expose a subset of its resource attributes to a parent module.
# We here are exposing our created vpc and security group to the parent module (root module here.)
output "vpc" {
    value = module.vpc
}

# Grouping related attributes into a single output value helps with code organization.
output "sg" {
    value = {
        lb      = module.lb_sg.security_group.id
        db      = module.db_sg.security_group.id
        websvr  = module.websvr_sg.security_group.id
    }
}