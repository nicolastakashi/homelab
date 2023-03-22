init:
	@packer init -upgrade ubuntu-server-focal.pkr.hcl
 
validate:
	@packer validate -var-file=credentials.pkr.hcl ubuntu-server-focal.pkr.hcl

build:
	@packer build -var-file=credentials.pkr.hcl ubuntu-server-focal.pkr.hcl