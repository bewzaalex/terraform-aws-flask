#!/usr/bin/env bash

if ! which aws2; then 
	printf "\n No AWSCLI exacutable found! Installing...\n"
	curl "https://d1vvhvl2y92vvt.cloudfront.net/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
	unzip awscliv2.zip
	sudo ./aws/install
	rm -f awscliv2.zip
    rm -rf ./aws
	printf "\nDone.\n"
fi

if [[ $(aws2 configure list-profiles | grep -c default) == 0 ]]; then
    aws2 configure
fi