const express = require("express");
const router = express.Router();
const moment = require("moment");

router.post("/get_avg_price_per_date_metric", (req, res) => {
	const {pool, body} = req;

	const startDate = moment(body.startDate);
	const endDate = moment(body.endDate);

	const query = `
		SELECT 
			outcome, 
			SUM(price * amount) / SUM(amount) avg_price, 
			date_part($1, fill_time) as date_part
		FROM fills
		WHERE (fill_time BETWEEN TO_TIMESTAMP($2) AND TO_TIMESTAMP($3)) AND market_id = $4
		GROUP BY outcome, date_part;
	`;

	const values = [body.dateMetric, startDate.unix(), endDate.unix(), body.marketId]

	pool.query(query, values, (error, results) => {
    if (error) {
      console.error(error)
      res.status(404).json(error)
		}

    res.status(200).json(results.rows);
	})
}); 

module.exports = router;