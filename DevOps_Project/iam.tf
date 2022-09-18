resource "aws_iam_role" "eksctl" {
  name = "eksctl_role"
  role = "${aws_iam_role.eksctl_role.id}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
}
EOF
tags = {
      tag-key = "kubernetes"
  }
}