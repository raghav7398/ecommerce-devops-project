resource "aws_iam_role" "cluster" {
  name = "${var.cluster_name}-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_eks_cluster" "example" {
  name = var.cluster_name
  role_arn = aws_iam_role.cluster.arn
  version  = var.cluster_version
  
  vpc_config {
    subnet_ids = var.subnet_ids
  }
  depends_on = [ aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy]
}

resource "aws_iam_role" "node" {
    name = "${var.cluster_name}-node-role"
    assume_role_policy = jsonencode({
        "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Principal": {
                "Service": [
                    "ec2.amazonaws.com"
                ]
            }
        }
    ]
})
  
}
resource "aws_iam_role_policy_attachment" "node-policy" {
    for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ])

    policy_arn = each.value
    role = aws_iam_role.node.name
  
}

resource "aws_eks_node_group" "node" {
    for_each = var.node_groups
    cluster_name = aws_eks_cluster.example.name
    node_group_name = each.key
    node_role_arn = aws_iam_role.node.arn
    subnet_ids = var.subnet_ids
    instance_types = each.value.instance_types
    capacity_type = each.value.capacity_type

    scaling_config {
    desired_size = each.value.scaling_config.desired_size
    max_size     = each.value.scaling_config.max_size
    min_size     = each.value.scaling_config.min_size
  }


  depends_on = [ 
    aws_iam_role_policy_attachment.node-policy
   ]
  
}

