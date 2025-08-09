
variable "dns_support" {
  type        = string
  default     = "true"
  description = "dns_support"
}

variable "dns_host" {
  type        = string
  default     = "true"
  description = "dns_hostnames"
}

variable "cidr_block_vpc" { 
  type        = string
  default     = null
  description = "vpc_cidrs"
}

variable "public_subnet" {
  type        = list
  default     = null
  description = "pub_subnets"
}

variable "private_subnet" {
  type        = list
  default     = null
  description = "pvt_subnets"
}
variable "DB_subnet" {
  type        = list
  default     = null
  description = "DB_subnets"
}

variable "az" {
  type        = list
  default     = null
  description = "az's"
}

# variable "private_az" {
#   type        = list
#   default     = ""
#   description = "pvt_az"
# }

# variable "cluster_name" {
#   type        = string
#   default     = ""
#   description = "clustername"
# }

variable "cluster_name_migration" {
  type        = string
  default     = ""
  description = "clusternamemigrate"
}

variable "private_subnet_tags" {
  type        = map(any)
  default     = null
  description = "private_subnet_tags"
}

variable "DB_subnet_tags" {
  type        = map(any)
  default     = null
  description = "DB_subnet_tags"
}
variable "public_subnet_tags" {
  type        = map(any)
  default     = null
  description = "public_subnet_tags"
}

variable "env" {
  type        = string
  default     = ""
  description = "env"
}










