resource "aws_security_group" "alb_sg" {
    vpc_id = var.vpc_id
    description = "enable http/https access on ports 80/443"
    name = "alb security group"
    ingress {
     description      = "http access"
     from_port        = 80
     to_port          = 80
     protocol         = "tcp"
     cidr_blocks      = [ "0.0.0.0/0" ]
    }
  
    ingress {
     description      = "https access"
     from_port        = 443
     to_port          = 443
     protocol         = "tcp"
     cidr_blocks      = [ "0.0.0.0/0" ]
    }

   egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [ "0.0.0.0/0" ]
   }

  tags = {
    Name = "alb_sg"
  }
}

resource "aws_security_group" "client_sg" {
   name = "client sg"
   description = "enable http/https access on elb sg"
   vpc_id = var.vpc_id
   ingress {
     description = "http access"
     from_port = 80
     to_port = 80
     protocol = "tcp"
     security_group = [aws_security_group.alb_sg.id]
   }
   egress {
     from_port = 0
     to_port = 0
     protocol = -1
     cidr_blocks = [ "0.0.0.0/0" ]
   }
  tags = {
    Name = "client_sg"
  }
}

resource "aws_security_group" "db_sg" {
   name = "database sg"
   description = "enable mysql access on port 3306 from client-sg"
   vpc_id = var.vpc_id
   ingress {
    description = "mysql access"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_group =  [aws_security_group.client_sg.id]
   }
  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = [ "0.0.0.0/0" ]
  }  
}
