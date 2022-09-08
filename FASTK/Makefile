# Note that Docker images with the schema version 2.1 built and pushed by Podman
# cause an error when pulled by Docker. It's safe to use docker to build Docker
# containers. See <https://discuss.dockstore.org/t/1972/12>.
DOCKER ?= docker
TAG = quay.io/junaruga/garg-fastk:latest

default : build
.PHONY : default

# Build container.
build :
	"$(DOCKER)" build --rm -t $(TAG) .
.PHONY : build

# List up the commands.
ls :
	"$(DOCKER)" run --rm -t $(TAG) ls -1 /usr/local/bin
.PHONY : ls

# Run container.
run :
	"$(DOCKER)" run --rm -t $(TAG) $(CMD)
.PHONY : run

# Clean all the container images.
clean :
	"$(DOCKER)" system prune -a -f
.PHONY : clean

# Test the local container.
test :
	"$(DOCKER)" run --rm -t $(TAG) bash -c "command -v FastK"
	"$(DOCKER)" run --rm -t $(TAG) bash -c "command -v Histex"
	"$(DOCKER)" run --rm -t $(TAG) bash -c "command -v Logex"
.PHONY : test

# Test pulling the remote container.
test-remote : pull-remote test
.PHONY : test-remote

pull-remote :
	"$(DOCKER)" pull --quiet $(TAG)
.PHONY : pull-remote

push :
	"$(DOCKER)" login quay.io
	"$(DOCKER)" push $(TAG)
.PHONY : push
