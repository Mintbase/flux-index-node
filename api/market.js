const express = require("express");
const router = express.Router();

router.post("/get", (req, res) => {
	const {pool, body} = req;
	
	const query = `
		SELECT 
			SUM(orders.filled) as filled,
			markets.*
		FROM markets
		LEFT JOIN orders
		ON markets.id = orders.market_id
		WHERE markets.id = ${body.marketId}
		GROUP BY markets.id
		ORDER BY filled
		LIMIT 1;
	`;
	
  pool.query(query, (error, results) => {
    if (error) {
      console.error(error)
      res.status(404).json(error)
		}
    res.status(200).json(results.rows)
	})
});


// TODO: should be last filled prices
router.post("/best_prices", (req, res) => {
	const {pool, body} = req;
	let whereString = null;
	
	if (body.filter && body.filter.categories) {
		console.log("get here", body.filter.categories)
		whereString = body.filter.categories.reduce((collector, item, index) => {
			if (index == 0 ) return collector;
			return collector + ` OR '${item}' = ANY (markets.categories)`
		},  `AND  '${body.filter.categories[0]}' = ANY(markets.categories)`)
	}

	const query = `
		SELECT 
			orders.market_id,
			orders.outcome,
			MAX(orders.price) best_price
		FROM orders
		LEFT JOIN markets
		ON orders.market_id = markets.id
		WHERE orders.closed = false AND markets.id = ${body.marketId}
		GROUP BY orders.market_id, orders.outcome
	`;
	
  pool.query(query, (error, results) => {
    if (error) {
      console.error(error)
      res.status(404).json(error)
		}

		const bestPricePerOutcome = {
			total: 0
		}

		const rows = results.rows;

		rows.forEach(outcomes => {
			if (!bestPricePerOutcome[outcomes.market_id]) bestPricePerOutcome[outcomes.market_id] = {};
			bestPricePerOutcome[outcomes.market_id][outcomes.outcome] = outcomes.best_price;
			bestPricePerOutcome.total += parseInt(outcomes.best_price);
		});
    res.status(200).json(bestPricePerOutcome)
	})
});

module.exports = router;