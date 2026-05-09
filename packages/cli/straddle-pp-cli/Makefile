.PHONY: build test lint install clean

build:
	go build -o bin/straddle-pp-cli ./cmd/straddle-pp-cli

test:
	go test ./...

lint:
	golangci-lint run

install:
	go install ./cmd/straddle-pp-cli

clean:
	rm -rf bin/

build-mcp:
	go build -o bin/straddle-pp-mcp ./cmd/straddle-pp-mcp

install-mcp:
	go install ./cmd/straddle-pp-mcp

build-all: build build-mcp
