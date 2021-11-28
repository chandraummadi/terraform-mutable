resource "null_resource" "app-deploy" {
  count = length(local.PRIVATE_IPS)
  triggers = {
    private_ip = element(local.PRIVATE_IPS, count.index)
  }
  provisioner "remote-exec" {
    connection {
      host     = element(local.PRIVATE_IPS, count.index)
      user     = local.ssh_user
      password = local.ssh_pass
    }
    inline = [
      "sudo yum install python3-pip -y",
      "sudo pip3 install pip --upgrade",
      "sudo pip3 install ansible",
      "ansible-pull -U https://github.com/chandraummadi/Devops-projects.git Ansible/roboshop/roboshop-pull.yml -e COMPONENT=${var.COMPONENT} -e ENV=dev"
    ]
  }
}
