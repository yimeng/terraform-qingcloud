terraform {
  required_providers {
    qingcloud = {
      source = "shaowenchen/qingcloud"
      version = "1.2.6"
    }
  }
}

# Create a eip
resource "qingcloud_eip" "init"{
    name = "连接第一个主机的地址"
    description = "主机-1"
    billing_mode = "traffic"
    bandwidth = 2
    need_icp = 0
}

# Create a web server
resource "qingcloud_instance" "init"{
    count = 1
    name = "master-${count.index}"
    image_id = "centos7x64d"
    instance_class = "0"
    keypair_ids = var.keypair_ids
    eip_id = qingcloud_eip.init.id
}

# Create security group
resource "qingcloud_security_group" "test"{
        name = "testsg"
}

output "ip" {
  value = qingcloud_eip.init.addr
}
