const sql = require("mssql/msnodesqlv8");
const bodyParser = require("body-parser");
const cors = require("cors");
const express = require("express");
const app = express();

const port = 3000;

app.use(express.static("./"));
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());
app.use(cors());
app.use(express.json());

const dbConfig = {
  server: "AMENN\\SQLEXPRESS",
  database: "footballAgencyDB",
  driver: "msnodesqlv8",
  options: {
    trustedConnection: true,
  },
};

async function runQuery(query) {
  await sql.connect(dbConfig);
  let res = await sql.query(query);
  sql.close();
  return res;
}

module.exports = { app, port, runQuery };
