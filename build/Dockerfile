# Stage 1: Build
FROM golang:1.27.0-bookworm AS builder

ARG TARGETOS
ARG TARGETARCH
ARG PROXYVARIANT

# Set environment variables for build time
ENV TARGETOS=${TARGETOS}
ENV TARGETARCH=${TARGETARCH}
ENV PROXYVARIANT=${PROXYVARIANT}

# Set the Current Working Directory inside the container
WORKDIR /go/src/pgproxy

# Copy go.mod and go.sum before other files for dependency caching
COPY go.mod go.sum ./

RUN echo Fetching project dependencies
RUN --mount=type=cache,target=/go/pkg/mod \
    GOOS=${TARGETOS} GOARCH=${TARGETARCH} go mod download

# Copy the source from the current directory to the Working Directory inside the container
COPY . .

RUN echo Building and installing the pgproxy service
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    GOOS=${TARGETOS} GOARCH=${TARGETARCH} CGO_ENABLED=0 go build  \
      -o /go/bin/proxyd /go/src/pgproxy/cmd/${PROXYVARIANT}

RUN ls -lrt /go/bin/proxyd

# Stage 2: Run
FROM debian:bookworm-slim AS final

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && \
    apt-get install -y --no-install-recommends netcat-openbsd ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Copy the Pre-built binary file from the previous stage
COPY --from=builder /go/bin/proxyd /proxy/proxyd

# Expose port 
EXPOSE 30000 30001 30002 30003 30004 30005 30006 30007 30008 30009

# Command to run the executable
ENTRYPOINT ["/proxy/proxyd"]