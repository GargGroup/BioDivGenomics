DOCKER ?= docker
TAG = garg-fastk

default : build
.PHONY : default

# Build container.
build :
	"$(DOCKER)" build --rm -t $(TAG) .

# List up the commands.
ls :
	"$(DOCKER)" run --rm -t $(TAG) ls -1 /usr/local/bin

# Run container.
run :
	"$(DOCKER)" run --rm -t $(TAG) $(CMD)

# Clean all the container images.
clean :
	"$(DOCKER)" system prune -a -f
