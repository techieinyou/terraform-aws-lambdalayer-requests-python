data "external" "os" {
  working_dir = path.module
  program = ["printf", "{\"os\": \"Linux\"}"]
}

locals {
  os = data.external.os.result.os
  check = local.os == "Windows" ? "We are on Windows" : "We are on Linux"
}

output "this_os" {
  value = data.external.os.result.os
}

/*
resource "null_resource" "create_folder" {

  # trigger on timestamp change will make sure local-exec runs always
  triggers = {
    always_run = "${timestamp()}"
  }

  # skip this block if the package already exists
  count = fileexists(pathexpand("python-requests.zip")) ? 0 : 1

  provisioner "local-exec" {
    command = <<-EOT
      if not exist tmp\\requests\\python\\lib\\python3.9\\site-packages mkdir tmp\\requests\\python\\lib\\python3.9\\site-packages
      pip3 install requests -t tmp\\requests\\python\\lib\\python3.9\\site-packages
      python -m zipfile -c python-requests.zip tmp\\requests\\python
    EOT
  }
}
*/

resource "null_resource" "create_folder" {

  # trigger on timestamp change will make sure local-exec runs always
  triggers = {
    always_run = "${timestamp()}"
  }

  # skip this block if the package already exists
  count = fileexists(pathexpand("tmp\\python-requests.zip")) ? 0 : 1

  # create folder and sub folders to install Python requests library
  provisioner "local-exec" {
    command = "if not exist tmp\\requests\\python\\lib\\python3.9\\site-packages mkdir tmp\\requests\\python\\lib\\python3.9\\site-packages"
  }
}

# Pre-requisite : Python 3
resource "null_resource" "install_python_requests" {

  # trigger on timestamp change will make sure local-exec runs always
  triggers = {
    always_run = "${timestamp()}"
  }

  # skip this block if the package already exists
  count = fileexists(pathexpand("tmp\\python-requests.zip")) ? 0 : 1

  # install Python requests library
  provisioner "local-exec" {
    command = "pip3 install requests -t tmp\\requests\\python\\lib\\python3.9\\site-packages"
  }
}

# Pre-requisite : Python 3
resource "null_resource" "create_package" {

  # trigger on timestamp change will make sure local-exec runs always
  triggers = {
    always_run = "${timestamp()}"
  }

  # skip this block if the package already exists
  count = fileexists(pathexpand("tmp\\python-requests.zip")) ? 0 : 1

  # create package of requests library folder
  provisioner "local-exec" {
    command = "python -m zipfile -c tmp\\python-requests.zip tmp\\requests\\python"
  }
}

# creates lambda layer
resource "aws_lambda_layer_version" "requests_python" {
  filename   = "./tmp/python-requests.zip"
  layer_name = var.layer_name

  compatible_runtimes = ["python3.9"]
}
