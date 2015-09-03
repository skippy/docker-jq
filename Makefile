NAME = skippy/jq
VERSION = 1.5

all: build

build:
	docker build -t $(NAME):$(VERSION) .

test:
	env NAME=$(NAME) VERSION=$(VERSION) ./tests.sh

tag_latest:
	docker tag -f $(NAME):$(VERSION) $(NAME):latest

release: test tag_latest
	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	curl -H "Content-Type: application/json" --data '{"build": true};' -X POST https://registry.hub.docker.com/u/skippy/jq/trigger/1ecf5d28-1f04-42c0-9a25-2fe9dce69290/
