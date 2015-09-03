NAME = skippy/jq
VERSION = 1.5

all: build

build:
	docker build -t $(NAME):$(VERSION) .

test:
	result=$(echo '{"foo": 2}' | docker run -i $(NAME):$(VERSION) '.foo') && [ "$result" == 2 ]

tag_latest:
	docker tag -f $(NAME):$(VERSION) $(NAME):latest

release: test tag_latest
	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	curl -H "Content-Type: application/json" --data '{"build": true};' -X POST https://registry.hub.docker.com/u/skippy/awscli/trigger/f90a97cd-2224-49e2-bd08-5e00d9ea032a/
