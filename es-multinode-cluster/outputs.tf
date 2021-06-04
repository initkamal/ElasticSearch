### The Ansible inventory file
resource "local_file" "AnsibleInventory" {
  content = templatefile("inventory.tmpl",
    { 
      instance-public-ip  = aws_instance.elasticsearch_instance.*.public_ip,
      instance-private-ip = aws_instance.elasticsearch_instance.*.private_ip,
      instance-id         = aws_instance.elasticsearch_instance.*.id
    }
  )
  filename = "inventory"
}