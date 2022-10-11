DOCKER ?= docker
HIFIASM_TAG = quay.io/biocontainers/hifiasm:0.16.1--h5b5514e_1
SHASTA_TAG = quay.io/biocontainers/shasta:0.8.0--h7d875b9_0
BLOBTOOLKIT_TAG = docker.io/genomehubs/blobtoolkit:3.3.4
MITOHIFI_TAG = docker.io/biocontainers/mitohifi:2.2_cv1
PSTOOLS_TAG = quay.io/biocontainers/pstools:0.2a3--hd03093a_1

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
	$(MAKE) test-remote -C FASTK
.PHONY : test-container-fastk

test-container-gene-scope-fk :
	$(MAKE) test-remote -C GENESCOPE.FK
.PHONY : test-container-gene-scope-fk

test-container-merqury-fk :
	$(MAKE) test-remote -C MERQURY.FK
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
