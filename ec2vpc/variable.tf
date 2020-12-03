variable "public_subnet_az" {}
variable "private_subnet_az" {}

variable "instance_type" {
    type = string
    default = "t2.micro"
}
variable "ami" {
    type = string
    default = "ami-0cda377a1b884a1bc"
}
variable "az" {
    type = string
    default = "ap-south-1a"
}
variable "public_key" {
    type = string
    default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDH8zv+HhZCHvmJ52u5eMNdh2Od8GDUJorWNHdumFQgnhR8cnkO0B4EU9jzXktFbB1BMMFzETZxAZ4VVj7634mvuXQG+dJZU4JUP83uhj7M8p2rK6mq647KHhdyWC+Qvw3zy9hAYbE93+e4uLaSyiNBqq0osSWELfvvpq/eCsBCvQMHrVNrSxzDzCh1QqIsAkUzzqGZ1nMq5gomF40y7VHV8d4Ej2WM5PhYV4RJAKBMtfXySFpKUlkHQ6O68GMLlJ86Ing961IiLxpUf3pgp9S7j9+9jWuYHJKIUR3T17Fh3I0D5TLViSva3PSir0VuXxT//+OKV2AWwDutbljJtUyiLmZsdSKv4fs1iErsZTonqBl8nnrr1880RkBXEJg6j6q/85FUks4cam02qxjLWILmdIJ+7SLOlxWu24J+BX6yA/imM3brkBC/9JX1wzqATEZFuFwy5UmngGZs1IPdWHX/hv+Psh+6ofl02RAIwCeRttyEvxeLpQpnLOmQjodztyc= saif@DESKTOP-SaiFi"
}