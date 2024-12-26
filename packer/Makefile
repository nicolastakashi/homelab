init:
	@packer init -upgrade ubuntu-server-noble-numbat.pkr.hcl
 
validate:
	@packer validate -var-file=credentials.pkr.hcl ubuntu-server-noble-numbat.pkr.hcl

build:
	@packer build -var-file=credentials.pkr.hcl ubuntu-server-noble-numbat.pkr.hcl