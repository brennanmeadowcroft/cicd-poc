FROM node:12.16.0

WORKDIR /usr/src/app

COPY ../package*.json ./

RUN npm install

COPY ../src .

EXPOSE 8000

CMD ["node", "server.js"]