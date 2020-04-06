SERVER_PORT ?= 8000
BASE_URL ?= http://localhost:8000

# THis is to make output more readable.  No need to edit
BPurple=\033[1;35m
BRed=\033[1;31m
Normal=\033[0m
Bold=\033[1;37m

build-app:
	docker build -t brennan/cicd-poc-app -f docker/app.Dockerfile .

build-tests:
	docker build -t brennan/cicd-poc-tests -f docker/test.Dockerfile .

run-app-docker: build-app
	@echo "${BPurple}App should be available at port: ${Bold}$(SERVER_PORT)${Normal}"
	docker run -p $(SERVER_PORT):$(SERVER_PORT) --env PORT=$(SERVER_PORT) -d --rm --name cicd-test-app brennan/cicd-poc-app:latest

run-app-local:
	node src/server.js

run-tests-local:
	BASE_URL=$(BASE_URL) node_modules/.bin/mocha -c test/*.e2e.js

run-tests-docker: build-tests
	@echo "${BPurple}Running tests against URL: ${Bold}$(BASE_URL)${Normal}"
	docker run --rm --network host --env BASE_URL=$(BASE_URL) --name cicd-test-e2e brennan/cicd-poc-tests:latest

run-tests-docker-compose: 
	docker-compose -f ./test/docker-compose.yml up --abort-on-container-exit --build --remove-orphans

run-system-docker-compose:
	docker-compose -f ./test/docker-compose.database.yml up --abort-on-container-exit --build --remove-orphans

stop-app:
	docker stop cicd-test-app