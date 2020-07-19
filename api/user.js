const express = require("express");
const router = express.Router();

router.post("/get_affiliate_earnings", (req, res) => {
	const {pool, body} = req;

	const query = `
		SELECT 
			affiliate_earnings
		FROM accounts
		WHERE id = $1;
	`;

	const values = [body.accountId]

	pool.query(query, values, (error, results) => {
    if (error) {
      console.error(error)
      res.status(404).json(error)
		}

    res.status(200).json(results.rows);
	})
}); 


router.post("/get_open_orders", (req, res) => {
	const {pool, body} = req;

	const query = `
		SELECT *, extract(epoch from order.creation_time) as creation_time
		FROM orders
		LEFT JOIN markets
		ON orders.market_id = market.id
		WHERE creator = $1 AND orders.closed = false AND market.end_time > ${new Date().getTime()};
	`;

	const values = [body.accountId]

	pool.query(query, values, (error, results) => {
    if (error) {
      console.error(error)
      res.status(404).json(error)
		}

    res.status(200).json(results.rows);
	})
}); 

router.post("/get_order_history", (req, res) => {
	const {pool, body} = req;

	const query = `
		SELECT *, extract(epoch from order.creation_time) as creation_time
		FROM orders
		WHERE creator = $1 AND orders.closed = true;
	`;
	const values = [body.accountId]

	pool.query(query, values, (error, results) => {
    if (error) {
      console.error(error)
      res.status(404).json(error)
		}

    res.status(200).json(results.rows);
	})
}); 

module.exports = router;