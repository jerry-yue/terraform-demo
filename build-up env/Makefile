#Makefile for MacOS
build:
	# install terraform
	brew tap hashicorp/tap;
	brew install hashicorp/tap/terraform;
	brew update;
	brew upgrade hashicorp/tap/terraform;
	terraform -install-autocomplete;
	
	# install aws cli
	curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg";
	sudo installer -pkg AWSCLIV2.pkg -target /;
	# verify terraform and aws cli
	terraform --version;
	aws --version;
	
.PHONY: build