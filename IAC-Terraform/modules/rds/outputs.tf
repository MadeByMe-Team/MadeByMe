output "endpoint" {
  value       = aws_rds_cluster.this.endpoint
  description = "The connection endpoint for the RDS Aurora cluster writer node"
}


output "endpoint_id" {
  value = one([
    for i, instance in aws_rds_cluster_instance.this :
    instance.id
    if local.instances_flat[i].is_writer
  ])

  description = "ID of the RDS Aurora cluster writer node"
}


output "reader_endpoint" {
  value       = aws_rds_cluster.this.reader_endpoint
  description = "The connection endpoint for the RDS Aurora cluster read-only replicas"
}
