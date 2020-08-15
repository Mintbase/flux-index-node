const express = require("express");
const router = express.Router();
const moment = require("moment");

router.post("/get", (req, res) => {
	const {pool, body} = req;
	
	const query = `
		SELECT 
			SUM(orders.filled) as filled,
			markets.*,
			extract(epoch from markets.creation_date) as creation_timestamp,
			extract(epoch from markets.end_date_time) as end_timestamp
		FROM markets
		LEFT JOIN orders
		ON markets.id = orders.market_id
		WHERE markets.id = $1
		GROUP BY markets.id
		ORDER BY filled
		LIMIT 1;
	`;

	const values = [body.marketId];
	
  pool.query(query, values, (error, results) => {
    if (error) {
      console.error(error)
      res.status(404).json(error)
		}
    res.status(200).json(results.rows)
	})
});


router.post("/market_prices", (req, res) => {
	const {pool, body} = req;

	const query = `
		SELECT 
			outcome,
			SUM(shares - shares_filled) as amount,
			MAX(price) best_price
		FROM orders
		WHERE closed = false AND market_id = $1
		GROUP BY outcome
		ORDER BY outcome
	`;

	const values = [body.marketId];
	
  pool.query(query, values, (error, results) => {
    if (error) {
      console.error(error) 
      res.status(404).json(error)
		}

		const marketPriceDepthPerOutcome = {}

		const rows = results.rows;
		
		for (let i = 0; i < rows.length; i++) {
			for (let x = 0; x < rows.length; x++) {
				let outcomeX = rows[x].outcome;
				if (x === i) continue;
				if(!marketPriceDepthPerOutcome[outcomeX]) marketPriceDepthPerOutcome[outcomeX] = {marketPrice: 100, depth: rows[i].amount};
				else if (marketPriceDepthPerOutcome[outcomeX].depth > rows[i].amount) {
					marketPriceDepthPerOutcome[outcomeX].depth = rows[i].amount;
				}
				marketPriceDepthPerOutcome[outcomeX].marketPrice -= rows[i].best_price;
			}
		}
    res.status(200).json(marketPriceDepthPerOutcome)
	})
});

router.post("/last_filled_prices", (req, res) => {
	const {pool, body} = req;
	console.log(body)
	const query = `
		SELECT fills.outcome, MAX(fills.price) AS price FROM fills 
		JOIN (
			SELECT 
				market_id, 
				MAX(block_height) as block_height
			FROM fills 
			WHERE market_id = $1 
			AND block_height = block_height
			GROUP BY market_id
		) f2
		ON fills.block_height = f2.block_height
		GROUP BY fills.outcome;
	`;

	const values = [body.marketId];
	
  pool.query(query, values, (error, results) => {
    if (error) {
      console.error(error)
      res.status(404).json(error)
		}

		const rows = results.rows;
		const lastFillPricePerOutcome = {}
		console.log(rows)
		rows.forEach(lastFill => {
			lastFillPricePerOutcome[lastFill.outcome] = lastFill.price;
		});
    res.status(200).json(lastFillPricePerOutcome)
	})
});


router.post("/get_open_orders_for_user", (req, res) => {
	const {pool, body} = req;

	const query = `
		SELECT
			id,
			price,
			shares,
			shares_filled,
			outcome
		FROM orders
		WHERE orders.creator = $1 AND closed = false AND market_id = $2;	
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

router.post("/get_share_balances_for_user", (req, res) => {
	const {pool, body} = req;

	const query = `
		SELECT
			price,
			SUM(shares_filled) owned_shares,
			outcome
		FROM orders
		WHERE orders.creator = $1 AND market_id = $2 AND shares_filled > 0
		GROUP BY price, outcome;
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


router.post("/get_avg_prices_for_date", (req, res) => {
	const {pool, body} = req;

	const startDate = moment(body.date);
	const endDate = moment(body.date).add(1, "day");

	const query = `
		SELECT outcome, SUM(price * amount) / SUM(amount) avg_price
		FROM fills
		WHERE (fill_time BETWEEN TO_TIMESTAMP($1) AND TO_TIMESTAMP($2)) AND market_id = $3
		GROUP BY outcome;
	`;

	const values = [startDate.unix(), endDate.unix(), body.marketId]

	pool.query(query, values, (error, results) => {
    if (error) {
      console.error(error)
      res.status(404).json(error)
		}

    res.status(200).json(results.rows);
	})
});


module.exports = router;