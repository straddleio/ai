DIST_DIR ?= dist/local

.PHONY: build test lint install clean build-mcp install-mcp build-all package-local package-readiness

build:
	go build -o bin/straddle-pp-cli ./cmd/straddle-pp-cli

test:
	go test ./...

lint:
	golangci-lint run

install:
	go install ./cmd/straddle-pp-cli

clean:
	rm -rf bin/ dist/local/

build-mcp:
	go build -o bin/straddle-pp-mcp ./cmd/straddle-pp-mcp

install-mcp:
	go install ./cmd/straddle-pp-mcp

build-all: build build-mcp

package-local:
	rm -rf "$(DIST_DIR)"
	mkdir -p "$(DIST_DIR)"
	go build -trimpath -ldflags "-s -w" -o "$(DIST_DIR)/straddle-pp-cli" ./cmd/straddle-pp-cli
	go build -trimpath -ldflags "-s -w" -o "$(DIST_DIR)/straddle-pp-mcp" ./cmd/straddle-pp-mcp
	test -x "$(DIST_DIR)/straddle-pp-cli"
	test -x "$(DIST_DIR)/straddle-pp-mcp"
	"$(DIST_DIR)/straddle-pp-cli" --help >/dev/null
	printf 'local package ready: %s\n' "$(DIST_DIR)"

package-readiness: package-local
