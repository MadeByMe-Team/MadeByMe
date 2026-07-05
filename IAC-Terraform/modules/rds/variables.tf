
variable "name" {
  type        = string
  description = "Name prefix used for the RDS cluster and associated resources"
}


variable "db_name" {
  type        = string
  description = "Name of the default database created inside the cluster"
}


variable "db_username" {
  type        = string
  description = "Master username for the RDS cluster administrator"
}


variable "db_password" {
  type        = string
  description = "Master password for the RDS cluster administrator"
}


variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for the RDS DB subnet group"
}


variable "security_group_ids" {
  type        = list(string)
  description = "List of VPC security group IDs attached to the RDS cluster"
}


variable "instances" {
  type = list(object({
    instance_class = string
    count          = number
    is_writer      = bool
  }))
  description = "Configuration list specifying instance classes, counts, and writer status"
}