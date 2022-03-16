data "aws_ami" "aws_ami" {
  most_recent = true
  owners      = ["${var.id_compte_ami}"]

  filter {
    name   = "name"
    values = ["${var.nom_ami}"]
  }
}

resource "aws_instance" "projet-ec2" {
  ami               = data.aws_ami.aws_ami.id
  instance_type     = var.type_instance
  key_name          = var.cle_ssh
  availability_zone = var.zone_dispo
  security_groups   = ["${var.securite_groupe}"]
  tags = {
    Name = "${var.ec2_name}-ec2"
  }

  provisioner "local-exec" {
    command = "echo l'appli est disponible sur cette url : http://${var.ip_public}:8080/ >> ip_connection.txt"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y git",
      "sudo amazon-linux-extras install -y ansible2",
      "git clone -b main https://github.com/${var.git_proprietaire}/${var.git_projet}.git",
      "cd ${var.git_projet}/ansible/",
      "ansible-galaxy install -r requirements.yml --force",
      "ansible-playbook -i hosts.yml projet.yml"
    ]
    connection {
      type        = "ssh"
      user        = "${var.utilisateur_ssh}"
      private_key = file("../.aws/${var.cle_ssh}.pem")
      host        = "${self.public_ip}"
    }
  }


}

