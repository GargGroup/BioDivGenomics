WDL_FILE = bio-diversity-genomics-garg.wdl
INPUT_FILE = bio-diversity-genomics-garg.inputs.json

default : lint run
.PHONY : default

# The `dockstore yaml` requires dockstore cli 1.13.0-rc.0 or later versions.
# https://discuss.dockstore.org/t/yaml-command-line-validator-tool/5577/7
lint : selinux-lint
	dockstore yaml validate --path .
.PHONY : lint

selinux-lint :
	script/lint-selinux.sh
.PHONY : selinux-lint

# Run the wdl file on local.
run :
	dockstore tool launch \
		--local-entry "$(WDL_FILE)" \
		--json "$(INPUT_FILE)"
.PHONY : run
