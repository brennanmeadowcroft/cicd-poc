const express = require("express");
const cors = require("cors");

const app = express();

app.use(cors());

app.get("/heartbeat", (req, res) => {
  console.log("Hearbeat requested");
  res.status(200).send("Hello");
});
app.get("/users", (req, res) => {
  console.log("GET /users");
  const data = {};
  res.status(200).send(data);
});
app.get("/accounts", (req, res) => {
  console.log("GET /accounts");
  // Get database credentials here

  // Get data here
  const data = {};

  // Send data
  res.status(200).send(data);
});

module.exports = app;
