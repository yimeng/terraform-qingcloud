resource "qingcloud_eip" "single"{
  name = "eip-single"
  description = "eip-single"
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



resource "qingcloud_instance" "master"{
  image_id = "centos74x64"
  instance_class = "0"
  keypair_ids = ["${qingcloud_keypair.arthur.id}"]
  security_group_id ="${qingcloud_security_group.basic.id}"
  eip_id = "${qingcloud_eip.single.id}"
}

output "ssh-shell" {
  value = "ssh root@${qingcloud_eip.single.addr}"
}



