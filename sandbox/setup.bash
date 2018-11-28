#!/bin/bash
# terraform setup

echo "Checking for terraform binary..."
if ! [ -e terraform/terraform ]; then
	echo "The terraform binary doesn't exist, checking for .zip file..."
	if ! [ -e terraform_*.zip ]; then
		echo "The terraform_*.zip file doesn't exist, curling it..."
		curl -LO https://releases.hashicorp.com/terraform/0.11.10/terraform_0.11.10_darwin_amd64.zip
		if [ -e terraform_*.zip ]; then
			echo "The curl was successfull, unzipping..."
			unzip terraform_*.zip -d terraform/build
		else 
			echo "Something went wrong, the terraform_*.zip file wasn't curled..."
			echo "The terraform_*.zip and terraform binary don't exist..."
		fi
	else
		echo "The terraform_*.zip file exists, unzipping it..."
		unzip terraform_*.zip -d terraform/build
	fi
else
	echo "The terraform binary exists, skipping..."
fi 

#### MAKING .PEM KEYS ####
if ! [ -d ./terraform/.oci ]; then
	echo "The directory .oci doesn't exist, creating it..."
	mkdir ./terraform/.oci
	echo "Creating the .pem keys..."
	openssl genrsa -out ./terraform/.oci/priv.pem 2048
	chmod go-rwx ./terraform/.oci/priv.pem
	openssl rsa -pubout -in ./terraform/.oci/priv.pem -out ./terraform/.oci/pub.pem
	echo "Copying pem public key to clipboard..."
	cat ./terraform/.oci/pub.pem | pbcopy #clip
else
	echo "The directory .oci exists, checking for keys..."
	if ! [ -e ./terraform/.oci/priv.pem ]; then
		echo "The .pem key pair doesn't exist, creating it..."
		openssl genrsa -out ./terraform/.oci/priv.pem 2048
		chmod go-rwx ./terraform/.oci/priv.pem
		openssl rsa -pubout -in ./terraform/.oci/priv.pem -out ./terraform/.oci/pub.pem
		echo "Copying pem public key to clipboard..."
		cat ./terraform/.oci/pub.pem | pbcopy #clip
	else
		echo "The .pem key pair exists, copying public key to clipboard..."
		cat ./terraform/.oci/pub.pem | pbcopy #clip
	fi
fi
#### MAKING .SSH KEYS ####
if ! [ -d ./terraform/.ssh ]; then
	echo "The directory .ssh doesn't exist, creating it..."
	mkdir ./terraform/.ssh
	echo "Creating ssh key pair..."
	ssh-keygen -f ./terraform/.ssh/sshkey -N ""
else
	echo "The directory .ssh exists, checking for keys..."
	if ! [ -e ./terraform/.ssh/sshkey ]; then
		echo "The ssh key pair doesn't exist, creating it..."
		ssh-keygen -f ./terraform/.ssh/sshkey -N ""
	else 
		echo "The ssh key pair exists..."
	fi
fi

## GET FINGERPRINT
#openssl rsa -pubout -outform DER -in ~/.oci/priv.pem | openssl md5 -c

## FIGURE OUT HOW TO EXPORT TO PATH!! AND HAVE IT STAY
#export PATH="$PATH:$(pwd)/terraform"
#echo $PATH

## SET PROXY
#export https_proxy=https://www-proxy-hqdc.us.oracle.com/

