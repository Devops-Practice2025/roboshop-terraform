
data "aws_vpc" "default" {
#    count   = var.use_default_vpc ? 1 : 0
  default = true
}
# variable "use_default_vpc" {
#     default = false
  
# }
