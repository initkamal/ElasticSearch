variable "region" {
  default = "us-east-1"

}

variable "instance_type" {
  default = "t3.small"

}

variable "elasticsearch_instance" {
  default = "ElasticSearch Instance"

}

variable "security_group" {
  default = "ElasticSearch SG"

}

variable "security_group_ports" {
  type        = list(number)
  description = "List of Ingress ports"
  default     = [22, 80, 443, 9200, 9300, 5601]

}

variable "key_pair" {
  default = "elasticsearch-deployer-key"

}
