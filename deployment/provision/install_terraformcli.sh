#!/usr/bin/env bash

if ! which terraform; then
    curl "https://releases.hashicorp.com/terraform/0.12.19/terraform_0.12.19_linux_amd64.zip" -o terraform.zip
    unzip terraform.zip
    rm -f terraform.zip
    sudo mv ./terraform /usr/local/bin/terraform
fi