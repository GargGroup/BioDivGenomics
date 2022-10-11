WDL_FILE = bio-diversity-genomics-garg.wdl
INPUT_FILE = test/input/bio-diversity-genomics-garg.inputs.json
TEST_FILE = test/test.py
PYTEST = $(shell script/find-pytest.sh)

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
	$(PYTEST) -v -s test/test.py::test_all
.PHONY : run

# Test the wdl files on local.
#
# This target requires "python3-pytest" and "python3-pytest-xdist" packages.
# Run the command below if you want to see the output.
# $ make test TEST_OPTS="-s"
#
# Run the command below if you want to run a specific test case.
# (e.g. "test_estimation")
# $ make test TEST_FILE="test/test.py::test_estimation"
test :
	$(PYTEST) -v $(TEST_OPTS) $(TEST_FILE)
.PHONY : test

# Test remote Docker containers used in our workflows.
test-containers :
	$(MAKE) test-containers -C container
.PHONY : test-containers
