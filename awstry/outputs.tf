output "ubuntu_ami_id" {
  value = data.aws_ami.ubuntu.id
}
output "debian_ami_id" {
  value = data.aws_ami.debian.id
}

