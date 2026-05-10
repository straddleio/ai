DIST_DIR ?= dist/local
GORELEASER ?= go run github.com/goreleaser/goreleaser/v2@latest

.PHONY: build test lint install clean build-mcp install-mcp build-all package-local package-readiness release-check release-snapshot

build:
	go build -o bin/straddle-pp-cli ./cmd/straddle-pp-cli

test:
	go test ./...

lint:
	golangci-lint run

install:
	go install ./cmd/straddle-pp-cli

clean:
	rm -rf bin/ build/ dist/

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
	cp .printing-press.json "$(DIST_DIR)/.printing-press.json"
	test -x "$(DIST_DIR)/straddle-pp-cli"
	test -x "$(DIST_DIR)/straddle-pp-mcp"
	test -f "$(DIST_DIR)/.printing-press.json"
	"$(DIST_DIR)/straddle-pp-cli" --help >/dev/null
	printf 'local package ready: %s\n' "$(DIST_DIR)"

package-readiness: package-local

release-check:
	$(GORELEASER) check

release-snapshot:
	$(GORELEASER) release --snapshot --clean --skip=publish
