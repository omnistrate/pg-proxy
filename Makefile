DOCKER_PLATFORM=linux/amd64,linux/arm64
PROXY_VERSION=0.10
TESTCOVERAGE_THRESHOLD=0
REPO_ROOT=$(shell git rev-parse --show-toplevel)

# Build info
CGO_ENABLED=0

.PHONY: all
all: tidy build 

.PHONY: docker-build
docker-build:
	docker buildx build --platform=${DOCKER_PLATFORM} -f cmd/build/Dockerfile -t omnistrate/postgres-proxy:${PROXY_VERSION} . --push

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
