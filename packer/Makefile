init:
	@packer init -upgrade ubuntu-server-jammy.pkr.hcl
 
validate:
	@packer validate -var-file=credentials.pkr.hcl ubuntu-server-jammy.pkr.hcl

build:
	@packer build -var-file=credentials.pkr.hcl ubuntu-server-jammy.pkr.hcl