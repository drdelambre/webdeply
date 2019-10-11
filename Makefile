DOCKER_COMPOSE := docker-compose -f fig.yml -f fig.prod.yml

start:
	# if NODE is specified, start that node
	# start all nodes otherwise
	$(DOCKER_COMPOSE) up -d $(NODE)

stop:
	# if NODE is specified, stop that node
	# stop all nodes otherwise
	$(DOCKER_COMPOSE) kill $(NODE)
	$(DOCKER_COMPOSE) rm -f $(NODE)

restart:
	# restarts the cluster or services
	$(MAKE) stop NODE=$(NODE)
	$(MAKE) start NODE=$(NODE)

build:
	# for forcing a rebuild of a node
	$(DOCKER_COMPOSE) build $(NODE)

logs:
	# livestreams all the sweet deets for a node
	$(DOCKER_COMPOSE) logs -f --tail=50 $(NODE)

test:
	# creating some test artifacts in ./test
	$(DOCKER_COMPOSE) run test

lint:
	# pass no pass
	$(DOCKER_COMPOSE) run test yarn lint


compile:
	# creating a compiled folder in ./static
	rm -rf ./static
	$(DOCKER_COMPOSE) run static

launch:
	bash -c 'while [[ "$$(curl -s --insecure -o /dev/null -w ''%{http_code}'' http://localhost:8080)" != "200" ]]; do sleep 5; done' && $(shell { command -v open || command -v xdg-open; }) http://localhost:8080/

# this needs to be generalized better, but launches chrome while accepting the local ssl certs for testing webassembly
# launch-chrome:
# 	bash -c 'while [[ "$$(curl -s --insecure -o /dev/null -w ''%{http_code}'' https://localhost:8443)" != "200" ]]; do sleep 5; done' && /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --user-data-dir=/tmp/foo --ignore-certificate-errors --unsafely-treat-insecure-origin-as-secure=https://localhost:8080 --new-window https://localhost:8080

