resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-subnets"
  subnet_ids = var.subnet_ids
}


resource "aws_rds_cluster" "this" {
  cluster_identifier          = var.name
  storage_encrypted           = true
  engine                      = "aurora-postgresql"
  engine_version              = "17.7"

  database_name               = var.db_name
  master_username             = var.db_username
  master_password             = var.db_password

  db_subnet_group_name        = aws_db_subnet_group.this.name
  vpc_security_group_ids      = var.security_group_ids

  skip_final_snapshot         = true

  tags = {
    Name = "main-rds-cluster-mbm"
  }
}


locals {
  instances_flat = flatten([
    for group in var.instances : [
      for i in range(group.count) : {
        instance_class = group.instance_class
        is_writer      = group.is_writer
      }
    ]
  ])
}


locals {
  writer_count = length([
    for i in var.instances : i
    if i.is_writer == true
  ])
}


resource "null_resource" "validate" {
  lifecycle {
    precondition {
      condition     = local.writer_count == 1
      error_message = "Exactly ONE writer group must be defined"
    }
  }
}


resource "aws_rds_cluster_instance" "this" {
  count = length(local.instances_flat)

  identifier         = "${var.name}-${count.index}"
  cluster_identifier = aws_rds_cluster.this.id

  instance_class = local.instances_flat[count.index].instance_class
  engine         = aws_rds_cluster.this.engine
  

  publicly_accessible = false

  tags = {
    Name = "rds-cluster-instance-${count.index}-mbm"
  }
}