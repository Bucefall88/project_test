#----------------------------------------------------------------------- 
# Name:         project-test
# Version:      1.0
# Security settings     
#-----------------------------------------------------------------------
# Create security groups
resource "aws_security_group" "sg_test" {
  name        = "sg_test"
  description = "Allow traffic"
  vpc_id      = aws_vpc.vpc_test.id
  ingress {
    description      = "sg_test_in"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    description      = "sg_test_out"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg_test"
  }
}
