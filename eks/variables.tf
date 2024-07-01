variable "region" {
    default = "us-east-1"
  
}

variable "cidr_range" {
    default = "10.0.0.0/16"
  
}

variable "cluster_name" {
  default = "demo"
  type = string
  description = "AWS EKS CLuster Name"
  nullable = false
}

