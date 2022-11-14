# Variables Configuration

variable "cluster-name" {
  default     = "eks-crossjoin"
  type        = string
  description = "The name of your EKS Cluster"
}

variable "aws-region" {
  default     = "eu-west-1"
  type        = string
  description = "The AWS Region to deploy EKS"
}

variable "availability-zones" {
  default     = ["eu-west-1a", "eu-west-1b","eu-west-1a","eu-west-1c"]
  type        = list
  description = "The AWS availability-zones allow "
}

variable "k8s-version" {
  default     = "1.23"
  type        = string
  description = "Required K8s version"
}

variable "kublet-extra-args" {
  default     = ""
  type        = string
  description = "Additional arguments to supply to the node kubelet process"
}

variable "public-kublet-extra-args" {
  default     = ""
  type        = string
  description = "Additional arguments to supply to the public node kubelet process"

}

variable "vpc-subnet-cidr" {
  default     = "10.0.0.0/16"
  type        = string
  description = "The VPC Subnet CIDR"
}

variable "private-subnet-cidr" {
  default     = ["10.0.0.0/19", "10.0.32.0/19", "10.0.64.0/19"]
  type        = list
  description = "Private Subnet CIDR"
}

variable "public-subnet-cidr" {
  default     = ["10.0.128.0/20", "10.0.144.0/20", "10.0.160.0/20"]
  type        = list
  description = "Public Subnet CIDR"
}

variable "node-instance-type" {
  default     = "t3.large"
  type        = string
  description = "Worker Node EC2 instance type"
}

variable "root-block-size" {
  default     = "20"
  type        = string
  description = "EBS block device"

}

variable "ec2-key-public-key" {
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDEuR1TU/mPrqK1qml7Kvt6SqAXODWgW2IJG297WNieY+KziLs5MDRdN/NaJIkva092FXiA6yewnm7Ze39TLZawwFQQpj55nNG7pHxy97fB2+uPcv2OKZRo4GJjPgshOu/XjNbMigvNgVd6mThB/Q29I5RwiAk/cSNvPAgeHniwkBBdod98F2MOHDjbFVXBAdr2BnocXUOlKf1sQwbyUohsDjXOFnVBMdlkApZW71dIwT6E8bFsQ2tPwwo8eAjagGulnCG1p3IQIlsQ6q5joW3tGj01LeHu25BzO2G0bzLPBSQYL47ulljxI99wS7mxBqYL4FZQqeyP4xrJFElZfq2Hscp/ry/dWGGB3xxBIqlnEMUvgQ7/vL15EmRrOtjJU+RNOPsb/kP2zqBuVDkSW1zael0tHJO6mIhg/odwFlNTn7BWd9fqpGHVTDrOZo73AIzml9i8IrKCJsRs/RiWnl0Vfjm6555wFtmcq3rxat5vmz6dl1CYh72SA9EM/DRARLE= guilherme@DESKTOP-H3EIV2E"
  type        = string
  description = "AWS EC2 public key data"
}