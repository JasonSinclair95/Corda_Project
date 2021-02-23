variable "cidr" {
    description = "cidr block for VPC"
    default = "10.20.0.0/16"
}

variable "public_cidr_A" {
    description = "cidr for public subnet A"
    default = "10.20.1.0/24"
}

variable "ami" {
    description = "instance image"
    default = "ami-022e8cc8f0d3c52fd"
}

variable "type" {
    description = "instance size"
    default = "t2.medium"
}

variable "key_name" {
    description = "key pair to SSH into instance"
    default = "aws_ubuntu"
}

variable "public_subnet_id" {
    default = "default value"
} 

variable "vpc_security_group_ids" {
    default = "default value"
}

variable "ingress_ports" {
  type        = list(number)
  description = "List of ingress ports"
  default     = [22]
}

variable "open-internet" {
    description     =   "CIDR block open to the internet"
    default         =   ["0.0.0.0/0"]
}

variable "outbound-port" {
    description     =   "Port open to allow outbound connection"
    default         =   "0"
}

