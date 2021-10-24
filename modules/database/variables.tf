variable "namespace" {
  type = string
}

# A type contraint of "any" type means Terraform will skip type checking.
# This allow for any kind of data structure to be passed in.
variable "vpc" {
  type = any
}

variable "sg" {
  type = any
}