
provider "aws" {
    region = "us-east-1"
  
}
locals {
  eks_cluster_name = "demo1"
}

resource "aws_cloudwatch_metric_alarm" "eks_apiserver_storage_size_bytes" {
  alarm_name = "eks-${local.eks_cluster_name}-apiserver-storage-size-bytes"

  comparison_operator = "GreaterThanOrEqualToThreshold"
  period              = "300"
  evaluation_periods  = "5"
  threshold           = "10" # 6Gb (max is 8Gb)

  alarm_description = "Detecting high ETCD storage usage when 75%+ is being used in ${local.eks_cluster_name} EKS cluster."
  alarm_actions     = [aws_sns_topic.eks_alerts.arn]

  statistic   = "Maximum"
  namespace   = "ContainerInsights"
  metric_name = "apiserver_storage_size_bytes"

  dimensions = {
    ClusterName = local.eks_cluster_name
  }
}

resource "aws_cloudwatch_metric_alarm" "eks_apiserver_storage_objects" {
  alarm_name = "eks-${local.eks_cluster_name}-apiserver-storage-objects"

  comparison_operator = "GreaterThanOrEqualToThreshold"
  period              = "300"
  evaluation_periods  = "5"
  threshold           = "10"

  alarm_description = "Detecting 100k+ ETCD storage objects in ${local.eks_cluster_name} EKS cluster."
  alarm_actions     = [aws_sns_topic.eks_alerts.arn]

  statistic   = "Maximum"
  namespace   = "ContainerInsights"
  metric_name = "apiserver_storage_objects"

  dimensions = {
    ClusterName = local.eks_cluster_name
  }
}

resource "aws_cloudwatch_metric_alarm" "eks_apiserver_request_duration_seconds" {
  alarm_name = "eks-${local.eks_cluster_name}-apiserver-request-duration-seconds"

  comparison_operator = "GreaterThanOrEqualToThreshold"
  period              = "300"
  evaluation_periods  = "5"
  threshold           = "1"

  alarm_description = "API server request duration exceeds 1 second in ${local.eks_cluster_name} EKS cluster."
  alarm_actions     = [aws_sns_topic.eks_alerts.arn]

  statistic   = "Average"
  namespace   = "ContainerInsights"
  metric_name = "apiserver_request_duration_seconds"

  dimensions = {
    ClusterName = local.eks_cluster_name
  }
}

resource "aws_cloudwatch_metric_alarm" "eks_rest_client_request_duration_seconds" {
  alarm_name = "eks-${local.eks_cluster_name}-rest-client-request-duration-seconds"

  comparison_operator = "GreaterThanOrEqualToThreshold"
  period              = "300"
  evaluation_periods  = "5"
  threshold           = "1"

  alarm_description = "REST client request duration exceeds 1 second in ${local.eks_cluster_name} EKS cluster."
  alarm_actions     = [aws_sns_topic.eks_alerts.arn]

  statistic   = "Average"
  namespace   = "ContainerInsights"
  metric_name = "rest_client_request_duration_seconds"

  dimensions = {
    ClusterName = local.eks_cluster_name
  }
}

resource "aws_cloudwatch_metric_alarm" "eks_etcd_request_duration_seconds" {
  alarm_name = "eks-${local.eks_cluster_name}-etcd-request-duration-seconds"

  comparison_operator = "GreaterThanOrEqualToThreshold"
  period              = "300"
  evaluation_periods  = "5"
  threshold           = "1"

  alarm_description = "ETCD request duration exceeds 1 second in ${local.eks_cluster_name} EKS cluster."
  alarm_actions     = [aws_sns_topic.eks_alerts.arn]

  statistic   = "Average"
  namespace   = "ContainerInsights"
  metric_name = "etcd_request_duration_seconds"

  dimensions = {
    ClusterName = local.eks_cluster_name
  }
}

resource "aws_sns_topic" "eks_alerts" {
  name = "eks-${local.eks_cluster_name}-alerts"
}

resource "aws_sns_topic_subscription" "email_eks_alerts" {
  topic_arn = aws_sns_topic.eks_alerts.arn
  protocol  = "email"
  endpoint  = "ankitanagarale1009@gmail.com"
}
