GIT_USER?=$(shell gh api user -q ".login") # gets current user using github cli if the variable is not already set
GIT_TOKEN?=$(shell gh config get -h github.com oauth_token) # gets current user using github cli if the variable is not already set
DOCKER_PLATFORM=linux/amd64
TESTCOVERAGE_THRESHOLD=0
REPO_ROOT=$(shell git rev-parse --show-toplevel)

# Build info
CGO_ENABLED=0
GOPRIVATE=github.com/omnistrate

.PHONY: all
all: tidy build 

.PHONY: docker-build
docker-build:
	docker buildx build --platform=linux/amd64,linux/arm64 -f cmd/build/Dockerfile -t njnjyyh/omnistrate-generic-proxy:latest . --push

.PHONY: tidy
tidy:
	echo "Tidy dependency modules"
	go mod tidy

.PHONY: build
build:
	echo "Building go binaries for service"
	go build -o proxyd ./cmd/cmd.go

.PHONY: install-dependencies
install-dependencies: lint-install sec-install

.PHONY: update-dependencies
update-dependencies:
	echo "Updating dependencies"
	go get -t -u ./...
	go mod tidy

.PHONY: run
run:
	echo "Running service" && \
    export DRY_RUN=true && \
    export LOG_LEVEL=debug && \
    export LOG_FORMAT=pretty && \
	go run ${BUILD_FLAGS} cmd/cmd.go