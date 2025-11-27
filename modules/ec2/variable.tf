variable "name" {}
variable "instance_type" {}
variable "allow_port" {}
variable "allow_sg_cidr" {}
variable "subnet_ids" {}
variable "vpc_id" {}
variable "env" {}
variable "bastion_nodes" {}
variable "capacity" {}
variable "asg" {}
variable "vault_token" {}
variable "internal" { default = null}
variable "allow_lb_sg_cidr" {
    default = []
}
variable "lb_subnet_ids" {
    default = []
}
