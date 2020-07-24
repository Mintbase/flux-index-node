const express = require("express");
const router = express.Router();

router.post("/get_trading", (req, res) => {
	const {pool, body} = req;

	const query = `
		SELECT SUM(shares_filled) * 100 as claimable FROM orders 
		LEFT JOIN markets
		ON orders.market_id = markets.id
		WHERE markets.finalized = true AND orders.creator = $1 AND markets.winning_outcome = orders.outcome AND markets.id = $2;
	`;
	
	const values = [body.accountId, body.marketId]

	pool.query(query, values, (error, results) => {
    if (error) {
      console.error(error)
      res.status(404).json(error)
		}

    res.status(200).json(results.rows);
	})
});
module.exports = router;