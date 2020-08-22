const express = require('express')
const bodyParser = require('body-parser')
const {pool} = require('./config')
const cors = require('cors');
const rateLimit = require("express-rate-limit")
const compression = require("compression");
const helmet = require("helmet");
const markets = require("./api/markets");
const market = require("./api/market");
const history = require("./api/historicData");
const orderbook = require("./api/orderbook");
const user = require("./api/user");
const earnings = require("./api/earnings");

const app = express()
app.use(compression())
app.use(helmet())
app.use(bodyParser.json())
app.use(bodyParser.urlencoded({extended: true}))
app.use(cors({credentials: true, origin: "*"}))
console.log("connectec")
app.use(function(req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header('Access-Control-Allow-Methods', 'DELETE, PUT, GET, POST, OPTION');
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  next();
});

const limiter = rateLimit({
  windowMs: 1 * 60 * 1000, // 1 minute
  max: 60, // 5 requests,
})
app.use(limiter);

app.get("/health_check", (req, res, next) => {
  console.log("get1");
  res.status(200).send("success");
});

app.use("/markets", (req, res, next) => {
  console.log("get2");
  req.pool = pool;
  next();
}, markets);

app.use("/market", (req, res, next) => {
  req.pool = pool;
  next();
}, market);

app.use("/history", (req, res, next) => {
  req.pool = pool;
  next();
}, history);

app.use("/orderbook", (req, res, next) => {
  req.pool = pool;
  next();
}, orderbook);

app.use("/user", (req, res, next) => {
  req.pool = pool;
  next();
}, user);

app.use("/earnings", (req, res, next) => {
  req.pool = pool;
  next();
}, earnings);

app.listen(process.env.PORT || 3000, () => {
  console.log(`Server listening`)
})
