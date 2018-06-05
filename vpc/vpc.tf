resource "qingcloud_eip" "vpc"{
  name = "eip-test"
  description = "eip-test"
  billing_mode = "traffic"
  bandwidth = 1
  need_icp = 0
}


resource "qingcloud_security_group" "basic"{
  name = "all"
  description = "没有限制"
}

resource "qingcloud_security_group_rule" "allow-in-tcp"{
  name = "允许所有tcp端口"
  security_group_id  = "${qingcloud_security_group.basic.id}"
  protocol = "tcp"
  priority = 1
  action = "accept"
  direction = 0
  from_port = "1"
  to_port = "65535"
}
resource "qingcloud_security_group_rule" "allow-in-udp"{
  name = "允许所有udp端口"
  security_group_id = "${qingcloud_security_group.basic.id}"
  protocol = "tcp"
  priority = 1
  action = "accept"
  direction = 0
  from_port = "1"
  to_port = "65535"
}
resource "qingcloud_security_group_rule" "allow-in-icmp"{
  name = "允许所有icmp"
  security_group_id = "${qingcloud_security_group.basic.id}"
  protocol = "icmp"
  priority = 1
  action = "accept"
  direction = 0
  from_port = "8"
  to_port = "0"
}


# qingcloud_keypair upload an SSH public key
# In this example, upload ~/.ssh/id_rsa.pub content.
# You may not have this file in your system, you will need to create your own SSH key.
resource "qingcloud_keypair" "arthur"{
  name = "yimeng"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

resource "qingcloud_vpc" "vpc"{
  name = "vpc-network"
  type = 1
  vpc_network = "172.31.0.0/16"
  security_group_id = "${qingcloud_security_group.basic.id}"
  description = "测试的网络"
  eip_id = "${qingcloud_eip.vpc.id}"
}

resource "qingcloud_vpc_static" "foo1"{
  vpc_id = "${qingcloud_vpc.vpc.id}"
  type = 1
  val1 = "80"
  val2 = "${qingcloud_instance.master.private_ip}"
  val3 = "80"
}

resource "qingcloud_vpc_static" "foo2"{
  vpc_id = "${qingcloud_vpc.vpc.id}"
  type = 1
  val1 = "443"
  val2 = "${qingcloud_instance.master.private_ip}"
  val3 = "22"
}

resource "qingcloud_vxnet" "vx"{
  name = "app vxnet"
  type = 1
  description = "应用的网络"
  vpc_id = "${qingcloud_vpc.vpc.id}"
  ip_network = "172.31.1.0/24"
}

resource "qingcloud_instance" "master"{
  image_id = "centos74x64"
  instance_class = "0"
  managed_vxnet_id = "${qingcloud_vxnet.vx.id}"
  keypair_ids = ["${qingcloud_keypair.arthur.id}"]
  security_group_id ="${qingcloud_security_group.basic.id}"
  provisioner "local-exec" {
    command = "echo ${qingcloud_eip.vpc.addr} > ip_address.txt"
  }
}

resource "qingcloud_instance" "slave"{
  count = 1

  name = "slave-${count.index}"
  image_id = "centos74x64"
  instance_class = "0"
  managed_vxnet_id = "${qingcloud_vxnet.vx.id}"
  keypair_ids = ["${qingcloud_keypair.arthur.id}"]
  security_group_id ="${qingcloud_security_group.basic.id}"
}

output "ip" {
  value = "${qingcloud_eip.vpc.addr}"
}


