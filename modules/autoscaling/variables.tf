variable "namespace" {
    type = string
}

variable "ssh_keypair" {
    type = string
}

# we used "any" here as a data type, cuz we pass data from networking module to autoscaling module.
# it's recommended to be used when passing data between modules only.
variable "vpc" {
    type = any
}

variable "sg" {
    type = any
}

variable "db_config" {
    # object is a collection of named attributes that each have their own type.
    type = object({
        user = string
        password = string
        database = string
        hostname = string
        port = string
    })
}