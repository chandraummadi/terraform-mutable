help:
	@IFS=$$'\n' ; \
        help_lines=(`fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//'`); \
        for help_line in $${help_lines[@]}; do \
            IFS=$$'#' ; \
            help_split=($$help_line) ; \
            help_command=`echo $${help_split[0]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
            help_info=`echo $${help_split[2]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
            printf "%-15s %s\n" $$help_command $$help_info ; \
        done

clean:
	@rm -rf .terraform

dev-apply: clean ## Create Dev Environment
	@terraform init -backend-config=env/dev-backend.tfvars
	@terraform apply -auto-approve -var-file=env/dev.tfvars

prod-apply: clean ## Create Prod Environment
	@terraform init -backend-config=env/prod-backend.tfvars
	@terraform apply -auto-approve -var-file=env/prod.tfvars

dev-destroy: clean ## Destroy Dev Environment
	@terraform init -backend-config=env/dev-backend.tfvars
	@terraform destroy -auto-approve -var-file=env/dev.tfvars

prod-destroy: clean ## Destroy Prod Environment
	@terraform init -backend-config=env/prod-backend.tfvars
	@terraform destory -auto-approve -var-file=env/prod.tfvars
