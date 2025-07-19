data "template_file" "apache" {
  template = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y ruby wget docker git
              sudo systemctl enable --now docker
              sudo usermod -a -G docker ec2-user
              sudo newgrp docker
              cd /home/ec2-user
              wget https://aws-codedeploy-ap-northeast-2.s3.ap-northeast-2.amazonaws.com/latest/install
              chmod +x ./install
              sudo ./install auto
              wget https://corretto.aws/downloads/latest/amazon-corretto-21-x64-linux-jdk.tar.gz
              tar -xzf amazon-corretto-21-x64-linux-jdk.tar.gz
              sudo mv amazon-corretto-21.0.7.6.1-linux-x64 /usr/lib/jvm/java-21-amazon-corretto
            EOF
}

data "template_file" "mariadb" {
  template = <<-EOF
              #!/bin/bash
              sudo yum update -y 
              sudo yum install -y mariadb105-server
              sudo systemctl start mariadb
              sudo systemctl status mariadb
            EOF
}

data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["137112412989"] # 공식 Amazon Linux 소유자 ID

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}