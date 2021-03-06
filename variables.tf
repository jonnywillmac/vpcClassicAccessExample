variable "ssh_public_key" {
  description = "The [public SSH key](https://cloud.ibm.com/docs/vpc-on-classic-vsi?topic=vpc-on-classic-vsi-ssh-keys) that you use to access your VPC virtual servers. Use the public key from the `~/.ssh/id_rsa.pub` file generated by the latest version of ssh-keygen tool, with the recommended key-size 2048."
}

variable "ssh_key_name" {
  default = "VPC_ssh_key"
  description = "The name of the public SSH key."
}

variable "image" {
  default = "6aec77ca-ab4a-459e-81dc-6e5ec9f99d4a"
  description = "The ID of the image that represents the operating system that you want to install on your VPC virtual server. To list available images, run `ibmcloud is images`. The default image is for an `ubuntu-16.04-amd64` OS."
}

variable "profile" {
  default = "bc1-2x8"
  description = "The profile of compute CPU and memory resources that you want your VPC virtual servers to have. To list available profiles, run `ibmcloud is instance-profiles`."
}
variable "region1" {
  default = "us-south"
  description = "Matches with provider and gives location of first VPC"
}
variable "region2" {
  default = "eu-de"
  description = "Matches with provider and gives location of second VPC"
}

variable "region3" {
  default = "jp-tok"
  description = "Matches with provider and gives location of third VPC"
}