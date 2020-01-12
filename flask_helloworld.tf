variable "project_dir" {
    default = "/srv/http/flask_helloworld"
}

provider "aws" {
  profile    = "default"
  region     = "us-east-1"
}

resource "aws_key_pair" "flask_helloworld" {
  key_name = "flask_helloworld_key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "flask_helloworld_ec_001" {
  ami           = "ami-2757f631" # Ubuntu 16.04.2 LTS
  instance_type = "t2.micro"
  key_name = aws_key_pair.flask_helloworld.key_name

  connection {
    type    = "ssh"
    user    = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host    = self.public_ip
  }

  # Install packages
  provisioner "remote-exec" {
    script = "provision/install_packages.sh"
  }

  # Create project dir
  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p ${var.project_dir}",
      "sudo chown ubuntu:www-data ${var.project_dir}",
      "sudo chmod 0775 ${var.project_dir}",
    ]
  }

  # Copy project files
  provisioner "file" {
    source      = "hello.py"
    destination = "${var.project_dir}/hello.py"
  }
  provisioner "file" {
    source      = "requirements.txt"
    destination = "${var.project_dir}/requirements.txt"
  }
  provisioner "file" {
    source      = "wsgi.py"
    destination = "${var.project_dir}/wsgi.py"
  }

  # Create virtualenv
  provisioner "remote-exec" {
    inline = [
      "cd ${var.project_dir}",
      "virtualenv -p /usr/bin/python3 ./env",
      "./env/bin/pip install -r requirements.txt",
    ]
  }

  # Configure uWSGI to run flask
  provisioner "file" {
    source      = "confs/uwsgi/flask_helloworld.ini"
    destination = "/tmp/flask_helloworld.ini"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo mv /tmp/flask_helloworld.ini /etc/uwsgi/apps-available/flask_helloworld.ini",
      "sudo ln -s /etc/uwsgi/apps-available/flask_helloworld.ini /etc/uwsgi/apps-enabled/",
      "sudo service uwsgi restart",
    ]
  }

  # Copy nginx config
  provisioner "file" {
    source      = "confs/nginx/flask_helloworld.conf"
    destination = "/tmp/flask_helloworld.conf"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo rm -f /etc/nginx/sites-enabled/default",
      "sudo mv /tmp/flask_helloworld.conf /etc/nginx/sites-available/flask_helloworld.conf",
      "sudo ln -s /etc/nginx/sites-available/flask_helloworld.conf /etc/nginx/sites-enabled/flask_helloworld.conf",
      "sudo nginx -t && sudo service nginx restart",
    ]
  }
}

output "flask_helloworld_ip" {
  value = aws_instance.flask_helloworld_ec_001.public_ip
}
