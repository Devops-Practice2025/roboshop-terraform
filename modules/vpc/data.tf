data "aws_vpc" "default" {
  filter {
    name   = "tag:default-vpc"
    values = ["default"]
  }
}

output "default_vpc_id" {
  value =  try(data.aws_vpc.default.id, "no-default-vpc")
}

