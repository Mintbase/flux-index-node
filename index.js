const express = require('express')
const bodyParser = require('body-parser')
const cors = require('cors')
const {pool} = require('./config')
const rateLimit = require("express-rate-limit")
const compression = require("compression");
const helmet = require("helmet");
const markets = require("./api/markets");
const market = require("./api/market");

const app = express()
app.use(compression())
app.use(helmet())
app.use(bodyParser.json())
app.use(bodyParser.urlencoded({extended: true}))

const isProduction = process.env.NODE_ENV === 'production';
const isPublic = process.env.NODE_TYPE === 'public';

const origin = {
  origin: isProduction ? 'https://www.example.com' : '*',
}
app.use(cors(origin))

if (isPublic) {
	const limiter = rateLimit({
		windowMs: 1 * 60 * 1000, // 1 minute
		max: 5, // 5 requests,
	})
	app.use(limiter);
}


app.use("/markets", (req, res, next) => {
  req.pool = pool;
  next();
}, markets);

app.use("/market", (req, res, next) => {
  req.pool = pool;
  next();
}, market);

app.listen(process.env.PORT || 3000, () => {
  console.log(`Server listening`)
})