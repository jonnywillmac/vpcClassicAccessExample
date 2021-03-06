
resource "random_id" "name1" {
  byte_length = 2
}

locals {
     ZONE1  = "${var.region1}-1"
     ZONE2  = "${var.region2}-1"
     ZONE3  = "${var.region3}-1"
   }

#Create VPC
resource "ibm_is_vpc" "vpc1" {
  provider = "ibm.us"
  name = "vpc-${var.region1}-${random_id.name1.hex}"
  classic_access = "true"
}
resource "ibm_is_vpc" "vpc2" {
  provider = "ibm.de"
  name = "vpc-${var.region2}-${random_id.name1.hex}"
  classic_access = "true"
}
resource "ibm_is_vpc" "vpc3" {
  provider = "ibm.tok"
  name = "vpc-${var.region3}-${random_id.name1.hex}"
  classic_access = "true"
}

#Create Single subnet per VPC
resource "ibm_is_subnet" "subnet1" {
  provider = "ibm.us"
  name            = "subnet-${var.region1}-${random_id.name1.hex}"
  vpc             = "${ibm_is_vpc.vpc1.id}"
  zone            = "${local.ZONE1}"
  total_ipv4_address_count = 256

  provisioner "local-exec" {
    command = "sleep 300"
    when    = "destroy"
  }
}
resource "ibm_is_subnet" "subnet2" {
  provider = "ibm.de"
  name            = "subnet-${var.region2}-${random_id.name1.hex}"
  vpc             = "${ibm_is_vpc.vpc2.id}"
  zone            = "${local.ZONE2}"
  total_ipv4_address_count = 256

  provisioner "local-exec" {
    command = "sleep 300"
    when    = "destroy"
  }
}
resource "ibm_is_subnet" "subnet3" {
  provider = "ibm.tok"
  name            = "subnet-${var.region3}-${random_id.name1.hex}"
  vpc             = "${ibm_is_vpc.vpc3.id}"
  zone            = "${local.ZONE3}"
  total_ipv4_address_count = 256

  provisioner "local-exec" {
    command = "sleep 300"
    when    = "destroy"
  }
}

resource "ibm_is_ssh_key" "sshkeyus" {
  provider   = "ibm.us"
  name       = "${var.ssh_key_name}-${random_id.name1.hex}"
  public_key = "${var.ssh_public_key}"
  
}
resource "ibm_is_ssh_key" "sshkeyde" {
  provider   = "ibm.de"
  name       = "${var.ssh_key_name}-${random_id.name1.hex}"
  public_key = "${var.ssh_public_key}"
}
resource "ibm_is_ssh_key" "sshkeytok" {
  provider   = "ibm.tok"
  name       = "${var.ssh_key_name}-${random_id.name1.hex}"
  public_key = "${var.ssh_public_key}"
}

resource "ibm_is_instance" "instance1" {
  provider = "ibm.us"
  name    = "instance-us-${random_id.name1.hex}"
  image   = "${var.image}"
  profile = "${var.profile}"

  primary_network_interface = {
    subnet     = "${ibm_is_subnet.subnet1.id}"
  }

  vpc       = "${ibm_is_vpc.vpc1.id}"
  zone      = "${local.ZONE1}"
  keys      = ["${ibm_is_ssh_key.sshkeyus.id}"]
}

resource "ibm_is_floating_ip" "floatingip1" {
  provider = "ibm.us"
  name   = "fip-us-${random_id.name1.hex}"
  target = "${ibm_is_instance.instance1.primary_network_interface.0.id}"
}

resource "ibm_is_security_group_rule" "us_sg1_tcp_rule" {
  provider   = "ibm.us"
  depends_on = ["ibm_is_floating_ip.floatingip1"]
  group      = "${ibm_is_vpc.vpc1.default_security_group}"
  direction  = "inbound"
  remote     = "0.0.0.0/0"

  tcp = {
    port_min = 22
    port_max = 22
  }
}

resource "ibm_is_security_group_rule" "us_sg1_icmp_rule" {
  provider   = "ibm.us"
  depends_on = ["ibm_is_floating_ip.floatingip1"]
  group      = "${ibm_is_vpc.vpc1.default_security_group}"
  direction  = "inbound"
  remote     = "0.0.0.0/0"

  icmp = {
    code = 0
    type = 8
  }
}

resource "ibm_is_security_group_rule" "us_sg1_app_tcp_rule" {
  provider   = "ibm.us"
  depends_on = ["ibm_is_floating_ip.floatingip1"]
  group      = "${ibm_is_vpc.vpc1.default_security_group}"
  direction  = "inbound"
  remote     = "0.0.0.0/0"

  tcp = {
    port_min = 80
    port_max = 80
  }
}

resource "ibm_is_instance" "instance2" {
  provider = "ibm.de"
  name    = "instance-de-${random_id.name1.hex}"
  image   = "${var.image}"
  profile = "${var.profile}"

  primary_network_interface = {
    subnet     = "${ibm_is_subnet.subnet2.id}"
  }

  vpc       = "${ibm_is_vpc.vpc2.id}"
  zone      = "${local.ZONE2}"
  keys      = ["${ibm_is_ssh_key.sshkeyde.id}"]
}

resource "ibm_is_floating_ip" "floatingip2" {
  provider = "ibm.de"
  name   = "fip-de-${random_id.name1.hex}"
  target = "${ibm_is_instance.instance2.primary_network_interface.0.id}"
}

resource "ibm_is_security_group_rule" "de_sg1_tcp_rule" {
  provider   = "ibm.de"
  depends_on = ["ibm_is_floating_ip.floatingip2"]
  group      = "${ibm_is_vpc.vpc2.default_security_group}"
  direction  = "inbound"
  remote     = "0.0.0.0/0"

  tcp = {
    port_min = 22
    port_max = 22
  }
}

resource "ibm_is_security_group_rule" "de_sg1_icmp_rule" {
  provider   = "ibm.de"
  depends_on = ["ibm_is_floating_ip.floatingip2"]
  group      = "${ibm_is_vpc.vpc2.default_security_group}"
  direction  = "inbound"
  remote     = "0.0.0.0/0"

  icmp = {
    code = 0
    type = 8
  }
}

resource "ibm_is_security_group_rule" "de_sg1_app_tcp_rule" {
  provider   = "ibm.de"
  depends_on = ["ibm_is_floating_ip.floatingip2"]
  group      = "${ibm_is_vpc.vpc2.default_security_group}"
  direction  = "inbound"
  remote     = "0.0.0.0/0"

  tcp = {
    port_min = 80
    port_max = 80
  }
}

resource "ibm_is_instance" "instance3" {
  provider = "ibm.tok"
  name    = "instance-tok-${random_id.name1.hex}"
  image   = "${var.image}"
  profile = "${var.profile}"

  primary_network_interface = {
    subnet     = "${ibm_is_subnet.subnet3.id}"
  }

  vpc       = "${ibm_is_vpc.vpc3.id}"
  zone      = "${local.ZONE3}"
  keys      = ["${ibm_is_ssh_key.sshkeytok.id}"]
}

resource "ibm_is_floating_ip" "floatingip3" {
  provider = "ibm.tok"
  name   = "fip-tok-${random_id.name1.hex}"
  target = "${ibm_is_instance.instance3.primary_network_interface.0.id}"
}

resource "ibm_is_security_group_rule" "tok_sg1_tcp_rule" {
  provider   = "ibm.tok"
  depends_on = ["ibm_is_floating_ip.floatingip3"]
  group      = "${ibm_is_vpc.vpc3.default_security_group}"
  direction  = "inbound"
  remote     = "0.0.0.0/0"

  tcp = {
    port_min = 22
    port_max = 22
  }
}

resource "ibm_is_security_group_rule" "tok_sg1_icmp_rule" {
  provider   = "ibm.tok"
  depends_on = ["ibm_is_floating_ip.floatingip3"]
  group      = "${ibm_is_vpc.vpc3.default_security_group}"
  direction  = "inbound"
  remote     = "0.0.0.0/0"

  icmp = {
    code = 0
    type = 8
  }
}

resource "ibm_is_security_group_rule" "tok_sg1_app_tcp_rule" {
  provider   = "ibm.tok"
  depends_on = ["ibm_is_floating_ip.floatingip3"]
  group      = "${ibm_is_vpc.vpc3.default_security_group}"
  direction  = "inbound"
  remote     = "0.0.0.0/0"

  tcp = {
    port_min = 80
    port_max = 80
  }
}
