FROM node:12.16.0

WORKDIR /usr/src/app

# This is because docker-compose doesn't wait for postgres to be ready
RUN git clone https://github.com/vishnubob/wait-for-it.git

COPY ./package*.json ./
RUN npm install

COPY ./test ./test

CMD ["node_modules/.bin/mocha", "-c", "test/*.e2e.js"]
