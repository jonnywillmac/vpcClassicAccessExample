provider "ibm" {
  ibmcloud_timeout = 300
  generation = "1"
  region = "us-south"
  alias = "us"
}

provider "ibm" {
  ibmcloud_timeout = 300
  generation = "1"
  region = "eu-de"
  alias = "de"
}

provider "ibm" {
  ibmcloud_timeout = 300
  generation = "1"
  region = "jp-tok"
  alias = "tok"
}
