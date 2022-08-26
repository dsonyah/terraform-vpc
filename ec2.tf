# resource "aws_instance" "web" {
#   ami                         = "ami-08d4ac5b634553e16"
#   instance_type               = "t2.micro"
#   vpc_security_group_ids      = [aws_security_group.frontend-sg.id]
#   key_name                    = "prod-kp"
#   subnet_id                   = aws_subnet.public-main-SN.id
#   associate_public_ip_address = true

#   root_block_device {
#     volume_size           = 30
#     delete_on_termination = true
#   }

#   tags = {
#     Name = "frontend-srv"
#   }
# }

# create security group rule for frontend srv
resource "aws_security_group" "frontend-sg" {
  name        = "frontend-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main-vpc.id

  ingress = [
    {
      description      = "ssh"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["74.132.208.143/32"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = true
    },

    {
      description      = "http"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = true
    },

    {
      description      = "icmp"
      from_port        = -1
      to_port          = -1
      protocol         = "icmp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = true
    }
  ]


  egress = [
    {
      description      = "for out going traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
  tags = {
    Name = "frontend-sg"
  }
}
