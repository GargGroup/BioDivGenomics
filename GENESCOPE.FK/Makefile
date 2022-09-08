DOCKER ?= docker
TAG = garg-gene-scope-fk

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
