FROM node:12.16.0

WORKDIR /usr/src/app

COPY ./package*.json ./

RUN npm install

COPY ./test ./test

CMD ["node_modules/.bin/mocha", "-c", "test/*.e2e.js"]
