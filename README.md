# CI with Docker Compose POC

This is a basic API with contract tests to demonstrate how to run these tests using Docker Compose so they could be easily run in a CI pipeline.

## Running the application

### Running Locally

Run the application locally (without Docker):

    make run-app-local

**Note:** If this is the first time you've run the application, run `npm install` to get the dependencies before starting the app.

This will start the web server locally at `http://localhost:8000`.  You can open <http://localhost:8000/heartbeat> and get the response: `Hello`.

### Running in Docker

You can also run the application locally as a Docker image:

    make run-app-docker

This will build the image and run it locally at `http://localhost:8000`.  You can open `http://localhost:8000/heartbeat` and get the response: `Hello`.

You can see details about the instance with `docker ps`.  The running container should be listed.  Note the name is `cicd-test-app`.

You can view the logs in the container with: `docker logs cicd-test-app`.  If you want to follow the logs in real-time, use `docker logs --follow cicd-test-app`.  Ctrl+C will exit from the logs.

<br>
<hr>

## Running the tests

Start the app in the container by following the instructions above and run the tests locally:

    make run-tests-local

This will run the E2E tests against a local URL.  The makefile defaults to `http://localhost:8000` as the base url but this can be changed if the tests are to be run against a particular URL by overriding it (covered later).

You should see tests run successfully in the console.  You can watch the entire process by opening a new terminal window and following the logs in the docker container as the tests are run.

### Running Tests Against a Different URL

The easiest way to simulate this is to run the server on a different port locally.  The default port we use with our Docker container is `8000` so let's use `3000` instead.

    PORT=3000 make run-app-local

You should see the message telling you the app is running.  Verify it by visiting <http://localhost:3000/heartbeat>.  You should see the message "Hello".

Now, run the tests in Docker against the local deployment:

    BASE_URL=http://localhost:3000 make run tests-docker

They should return successfully.

### Running Tests In Docker-Compose

We want to be able to run our tests within the CI pipeline without requiring a separate deployment to another environment.  Docker Compose allows us to do this as it will create both 

<br>
<hr>

## What is with the docker run commands?

There are several flags added to the docker run command.  Here is a quick reference about what they are doing to take out some of the mystery:

`-p` maps ports between the host machine and the container
`--env` inserts an environment variable into the container
`d` detaches the container so that it can be run in the background;
`--rm` will remove the image entirely after being stopped.  This helps to keep your Docker clean during this POC
`--network host` connects a running docker container to the network on the host machine.  It allows access to `localhost` from inside the container.
