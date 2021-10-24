# namespace variable is a project identifier (we an name it using projectName-environmentVersion)
# All that matters is that our project identifier is unique and descriptive.
# we will use it in each module for resource naming.
# required variable to run the project.
variable "namespace" {
  description = "The project namespace to use for unique resource naming"
  type = string
}

# when we get to chapter 9, we need to check how we can get a SSH keypair (delete this line after we make this action).
# ssh_keypair is an optional variable.
variable "ssh_keypair" {
  description = "SSH keypair to use for EC2 instance"
  default = null
  type = string
}

# region is an optional variable.
variable "region" {
  description = "AWS region"
  default = "eu-central-1"
  type = string
}