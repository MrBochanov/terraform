provider "aws" {
  region = "eu-central-1"
}

#создаем эластик ip, чтоб не менялся ip после удаления-создания машины
resource "aws_eip" "my_static_ip" {
  instance = aws_instance.my_aws_webserver[0].id #так как ниже создается массив из одной машины, надо указать [0]

}
#создается машина и привязывается к создаваемой SG
resource "aws_instance" "my_aws_webserver" {
  count                  = 1
  ami                    = "ami-0e342d72b12109f91"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.SG_for_WebServer.id]
  user_data = templatefile("user_data.sh.tpl", {
    f_name = "Evgeniy",
    l_name = "Bochanov",
    names  = ["Vasya", "Petya", "Kolya", "Bob", "Donald", "Pasha"]
  })

  tags = {
    Name    = "My Ubuntu WebServer in AWS"
    Owner   = "Evgeniy Bochanov"
    Project = "Terraform Lessons"
  }

  lifecycle {
    #prevent_destroy = true # защита от удаления
    #ignore_changes  = ["ami", "user_data"] # игнор если изменены эти значения
    create_before_destroy = true #сначала создаст новую машину, потом удалит старую
  }
}

#создается SG для WebServer
resource "aws_security_group" "SG_for_WebServer" {
  name        = "Web Server Security Group"
  description = "Allow http traffic"

  #пример динамического кода - много одинаковых портов
  dynamic "ingress" {
    for_each = ["80", "443", "8080", "1541", "9092"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  #если для одного правила другие - прописывается отсдельно, то есть статикой
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.10.10.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http_security_group"
  }
}
