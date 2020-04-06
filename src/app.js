const express = require("express");
const cors = require("cors");
const { Pool } = require("pg");

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
app.get("/accounts", async (req, res) => {
  console.log("GET /accounts");
  // Get database credentials here
  try {
    const db = new Pool({
      database: process.env.DB_NAME,
      host: process.env.DB_HOST,
      password: process.env.DB_PASSWORD,
      port: 5432,
      user: process.env.DB_USER,
    });
    console.log("Connected");

    // Get data here
    const data = await db.query("SELECT * FROM accounts");
    console.log("Data received");

    // Send data
    res.status(200).send(data.fields);
  } catch (err) {
    console.error("Error connecting", err.message);
    res.status(500).send(err.message);
  }
});

module.exports = app;
