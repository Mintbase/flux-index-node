const express = require("express");
const router = express.Router();

router.post("/get_trading_earnings", (req, res) => {
	const {pool, body} = req;
	const marketId = body.marketId;
	const accountId = body.accountId;

	const query = `
		SELECT 
			orders.outcome, 
			SUM(orders.shares_filled * 100) 
		FROM orders 
		WHERE orders.creator = $1 AND orders.market_id = $2 
		GROUP BY orders.outcome;
	`;
	
	const values = [accountId, marketId]

	pool.query(query, values, (error, results) => {
			
		if (error) {
			console.error(error)
			return res.status(404).json(error)
		}

    	return res.status(200).json(results.rows);
	})
});

module.exports = router;