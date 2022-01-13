#----------------------------------------------------------------------- 
# Name:         project-test
# Version:      1.0
# Variables    
#-----------------------------------------------------------------------

variable "aws_region" {
  description = "AWS Region"
  default     = "eu-central-1"
}

variable "aws_credentials" {
  description = "AWS Credentials"
  default     = "~/.aws/credentials"
}

variable "public_key" {
  description = "Instances key"
  default     = "~/.aws/project_test.pub"
}

variable "privat_key" {
  description = "Instances key"
  default     = "~/.aws/project_test"
}
