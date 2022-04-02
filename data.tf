data "aws_ami" "ami" {
  most_recent      = true
  name_regex       = "base-with-ansible"
  owners           = ["self"]

}

data "aws_secretsmanager_secret" "common" {
  name = "common/ssh"
}

data "aws_secretsmanager_secret_version" "secret" {
  secret_id = data.aws_secretsmanager_secret.common.id
}


locals {
  NEXUS_USERNAME = nonsensitive(jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["NEXUS_USERNAME"])
  NEXUS_PASSWORD = nonsensitive(jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["NEXUS_PASSWORD"])
  SSH_USERNAME = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["SSH_USERNAME"]
  SSH_PASSWORD = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["SSH_PASSWORD"]
}