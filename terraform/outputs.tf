output "endpoint" {
  description = "EKS Cluster Endpoint"
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  description = "Certificate Data for cluster"
  value = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}

output "aurora-endpoint" {
  description = "AWS aurora instance Endpoint"
  value = module.aurora_postgresql.cluster_endpoint
}
