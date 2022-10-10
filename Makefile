WDL_FILE = bio-diversity-genomics-garg.wdl
INPUT_FILE = test/input/bio-diversity-genomics-garg.inputs.json
TEST_FILE = test/test.py
PYTEST = $(shell script/find-pytest.sh)
DOCKER ?= docker
HIFIASM_TAG = quay.io/biocontainers/hifiasm:0.16.1--h5b5514e_1
SHASTA_TAG = quay.io/biocontainers/shasta:0.8.0--h7d875b9_0
BLOBTOOLKIT_TAG = docker.io/genomehubs/blobtoolkit:3.3.4
MITOHIFI_TAG = docker.io/biocontainers/mitohifi:2.2_cv1
PSTOOLS_TAG = quay.io/biocontainers/pstools:0.2a3--hd03093a_1

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
test-containers : \
	test-container-fastk \
	test-container-gene-scope-fk \
	test-container-merqury-fk \
	test-container-hifiasm \
	test-container-shasta \
	test-container-blobtoolkit \
	test-container-mitohifi \
	test-container-pstools
	@echo "OK"
.PHONY : test-containers

test-container-fastk :
	$(MAKE) test-remote -C container/FASTK
.PHONY : test-container-fastk

test-container-gene-scope-fk :
	$(MAKE) test-remote -C container/GENESCOPE.FK
.PHONY : test-container-gene-scope-fk

test-container-merqury-fk :
	$(MAKE) test-remote -C container/MERQURY.FK
.PHONY : test-container-merqury-fk

# hifiasm
# https://biocontainers.pro/tools/hifiasm
# https://quay.io/repository/biocontainers/hifiasm
test-container-hifiasm :
	"$(DOCKER)" run --rm -t "$(HIFIASM_TAG)" hifiasm --version
.PHONY : test-container-hifiasm

# shasta
# https://biocontainers.pro/tools/shasta
# https://quay.io/repository/biocontainers/shasta
test-container-shasta :
	"$(DOCKER)" run --rm -t "$(SHASTA_TAG)" shasta --version
.PHONY : test-container-shasta

# blobtoolkit
# https://github.com/blobtoolkit/blobtoolkit
# https://hub.docker.com/r/genomehubs/blobtoolkit
test-container-blobtoolkit :
	"$(DOCKER)" run --rm -t "$(BLOBTOOLKIT_TAG)" blobtools --version
.PHONY : test-container-blobtoolkit

# mitohifi
# https://biocontainers.pro/tools/mitohifi
# https://hub.docker.com/r/biocontainers/mitohifi
test-container-mitohifi :
	"$(DOCKER)" run --rm -t "$(MITOHIFI_TAG)" mitohifi.py --version
.PHONY : test-container-mitohifi

# pstools
# https://github.com/shilpagarg/pstools
# https://biocontainers.pro/tools/pstools
# https://quay.io/repository/biocontainers/pstools
test-container-pstools :
	"$(DOCKER)" run --rm -t "$(PSTOOLS_TAG)" pstools version
.PHONY : test-container-pstools
