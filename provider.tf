# AWS provider
provider "aws" {
  profile = "default"
  region = "eu-west-1"
}

# Template provider
provider "template" {
  version = "~> 2.1"
}

# Random generator provider
provider "random" {
  version = "~> 2.3"
}
