## Build the FastAPI Docker image.
##
.PHONY: build
build:
	@docker build . -t cadmusthefounder/lnd:take-the-helm-0.1.0


## Build the FastAPI Docker image.
##
.PHONY: run
run:
	@docker run -p 8000:8000 cadmusthefounder/lnd:take-the-helm-0.1.0
