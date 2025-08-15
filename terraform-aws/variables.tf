variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "project" {
  description = "Project name prefix"
  type        = string
  default     = "devops-portfolio"
}

variable "public_key_path" {
  description = "Path to your SSH public key for EC2"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}
