/*
moudle "eks" {
    source  = "terraform-aws-modules/eks/aws"
    version = "~> 18.0"

    cluster_name = "${var.aws_default_name}-cluster"
    cluster_version = "1.21"

    vpc_id =
    subnet_ids =

     # EKS Managed Node Group(s)
    eks_managed_node_group_defaults = {
        disk_size      = 50
        instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
    }

    eks_managed_node_groups = {
        blue = {}
        green = {
        min_size     = 1
        max_size     = 10
        desired_size = 1

        instance_types = ["t3.large"]
        capacity_type  = "SPOT"
        }
    }
}
*/