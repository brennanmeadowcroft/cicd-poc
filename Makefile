SERVER_PORT ?= 8000
BASE_URL ?= http://localhost:8000

# THis is to make output more readable.  No need to edit
BPurple=\033[1;35m
BRed=\033[1;31m
Normal=\033[0m
Bold=\033[1;37m

build-app:
	docker build -t brennan/cicd-poc-app -f docker/app.Dockerfile .

build-database:
	docker build -t brennan/cicd-poc-database -f docker/database.Dockerfile .

build-tests:
	docker build -t brennan/cicd-poc-tests -f docker/test.Dockerfile .

clean-images:
	docker rmi --force brennan/cicd-poc-database brennan/cicd-poc-tests brennan/cicd-poc-app test_e2e_tests test_database test_tests test_api

clean-containers:
	docker rm test_e2e_tests_1 test-app database

run-app-docker: build-app
	@echo "${BPurple}App should be available at port: ${Bold}$(SERVER_PORT)${Normal}"
	docker run -p $(SERVER_PORT):$(SERVER_PORT) --env PORT=$(SERVER_PORT) -d --rm --name cicd-test-app brennan/cicd-poc-app:latest

run-app-local:
	node src/server.js

run-database-local:
	# "Local" is through docker in this case because it's just easier in this case
	docker run -p 5432:5432 -e POSTGRES_PASSWORD=secret -e POSTGRES_USER=admin -e POSTGRES_DB=testdb --name cicd-test-database brennan/cicd-poc-database:latest


run-tests-local:
	BASE_URL=$(BASE_URL) node_modules/.bin/mocha -c test/*.e2e.js

run-tests-docker: build-tests
	@echo "${BPurple}Running tests against URL: ${Bold}$(BASE_URL)${Normal}"
	docker run --rm --network host --env BASE_URL=$(BASE_URL) --name cicd-test-e2e brennan/cicd-poc-tests:latest

run-database-tests-docker-compose: build-database
	docker-compose -f ./test/docker-compose.database.yml up --abort-on-container-exit --build --remove-orphans

run-tests-docker-compose: 
	# With the addition of the database tests, this will actually fail.  Look for successes on the endpoints that don't involve the database
	docker-compose -f ./test/docker-compose.yml up --abort-on-container-exit --build --remove-orphans

run-system-docker-compose:
	docker-compose -f ./test/docker-compose.database.yml up --abort-on-container-exit --build --remove-orphans

stop-app:
	docker stop cicd-test-app