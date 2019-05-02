resource "random_string" "content" {
  length  = 1024
  special = true
}

resource "local_file" "foo" {
  sensitive_content = "${random_string.content.result}"
  filename          = "foo.bar"
}

data "local_file" "foo" {
  filename = "foo.bar"

}

output "name" {
  value     = "${data.local_file.foo.content}"
  sensitive = true
}

/*
terraform plan
terraform taint random_string.content
terraform apply
terraform output
 */