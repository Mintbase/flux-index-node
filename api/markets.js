const express = require("express");

const router = express.Router();
router.post("/get", async (req, res) => {
	const {pool, body} = req;

	let whereString = "";
	const categoryValues = [] // [categories[0], ...items]
	if (body.filter && body.filter.categories) {
		whereString = body.filter.categories.reduce((collector, item, index) => {
			categoryValues.push(body.filter.categories[index]);
			if (index == 0 ) return collector;
			return collector + ` OR $${index + 1} = ANY (markets.categories)`
		},  `AND $1 = ANY(markets.categories)`)
	}
	let limit = body.limit || 20;
	let limitString = `LIMIT $${categoryValues.length + 1}`;
	let offset =  body.offset || 0;
	let offsetString = `OFFSET $${categoryValues.length + 2}`
	const values = categoryValues.concat([limit, offset]);

	const query = `
		SELECT 
			SUM(orders.filled) as volume,
			markets.*,
			extract(epoch from markets.creation_date) as creation_timestamp,
			extract(epoch from markets.end_date_time) as end_timestamp
		FROM markets
		LEFT JOIN orders
		ON markets.id = orders.market_id 
		WHERE markets.end_date_time > to_timestamp(${new Date().getTime()} / 1000) ${whereString && whereString}
		GROUP BY markets.id
		ORDER BY volume
		${limitString} ${offsetString}
		;
	`;

  pool.query(query, values, (error, results) => {
    if (error) {
      console.error(error)
      res.status(404).json(error)
		}
    res.status(200).json(results.rows)
	})
});

router.post("/best_prices", (req, res) => {
	const {pool, body} = req;

	let whereString = "";
	const categoryValues = [] // [categories[0], ...items]
	if (body.filter && body.filter.categories) {
		whereString = body.filter.categories.reduce((collector, item, index) => {
			categoryValues.push(body.filter.categories[index]);
			if (index == 0 ) return collector;
			return collector + ` OR $${index + 1} = ANY (markets.categories)`
		},  `WHERE  $1 = ANY(markets.categories)`)
	}

	let limit = body.limit || 20;
	let limitString = `LIMIT $${categoryValues.length + 1}`;
	let offset =  body.offset || 0;
	let offsetString = `OFFSET $${categoryValues.length + 2}`
	const values = categoryValues.concat([limit, offset]);


	const query = `
		SELECT 
			orders.market_id,
			orders.outcome,
			MAX(orders.price) best_price
		FROM orders
		JOIN (SELECT * from markets ${limitString} ${offsetString}) markets
		ON orders.market_id = markets.id
		WHERE orders.closed = false ${whereString && whereString} AND markets.end_date_time > to_timestamp(${new Date().getTime()} / 1000)
		GROUP BY orders.market_id, orders.outcome;
	`;
	
  pool.query(query, values, (error, results) => {
    if (error) {
      console.error(error)
      res.status(404).json(error)
		}

		const marketPricePerOutcome = {
			total: 0
		}

		const rows = results.rows;

		rows.forEach(outcomes => {
			if (!marketPricePerOutcome[outcomes.market_id]) marketPricePerOutcome[outcomes.market_id] = {};
			marketPricePerOutcome[outcomes.market_id][outcomes.outcome] = outcomes.best_price;
			marketPricePerOutcome.total += parseInt(outcomes.best_price);
		});
    res.status(200).json(marketPricePerOutcome)
	})
});


router.post("/last_filled_prices", (req, res) => {
	const {pool, body} = req;

	let whereString = "";
	const categoryValues = [] // [categories[0], ...items]
	if (body.filter && body.filter.categories) {
		whereString = body.filter.categories.reduce((collector, item, index) => {
			categoryValues.push(body.filter.categories[index]);
			if (index == 0 ) return collector;
			return collector + ` OR $${index + 1} = ANY (markets.categories)`
		},  `AND  $1 = ANY(markets.categories)`)
	}
	let limit = body.limit || 20;
	let limitString = `LIMIT $${categoryValues.length + 1}`;
	let offset =  body.offset || 0;
	let offsetString = `OFFSET $${categoryValues.length + 2}`
	const values = categoryValues.concat([limit, offset]);

	const query = `
		SELECT 
			f1.outcome, 
			f1.market_id,
			f1.price
		FROM fills f1
		JOIN (
			SELECT 
				fills.market_id,
				fills.outcome,
				MAX(fills.fill_time) as fill_time
			FROM fills
			JOIN (
				SELECT * FROM markets
				WHERE markets.end_date_time > to_timestamp(${new Date().getTime()} / 1000) ${whereString && whereString}
				${limitString} ${offsetString}
			) markets
			ON fills.market_id = markets.id
			WHERE fills.fill_time < to_timestamp(${new Date().getTime()} / 1000)
			GROUP BY fills.market_id, fills.outcome
		) f2 ON f1.market_id = f2.market_id
			AND f1.outcome = f2.outcome
			AND f1.fill_time = f2.fill_time
		;
	`;
	
  pool.query(query, values, (error, results) => {
    if (error) {
      console.error(error)
      res.status(404).json(error)
		}

		const rows = results.rows;
		const lastFillPricePerOutcome = {}
		rows.forEach(lastFill => {
			if (!lastFillPricePerOutcome[lastFill.market_id]) lastFillPricePerOutcome[lastFill.market_id] = {};
			lastFillPricePerOutcome[lastFill.market_id][lastFill.outcome] = lastFill.price;
		});
    res.status(200).json(lastFillPricePerOutcome)
	})
});



// // TODO: should be last filled prices
// router.get("/set_fill_script", (req, res) => {
// 	const {pool} = req;

// 	const query = `
// 		SELECT 
// 			id, 
// 			creator, 
// 			outcome, 
// 			market_id, 
// 			filled, 
// 			price
// 		FROM public.orders 
// 		WHERE filled > 0;
// 	`;
	
//   pool.query(query, async (error, results) => {
//     if (error) {
//       console.error(error)
//       return res.status(404).json(error)
// 		}

// 		results.rows.forEach(row => {
// 			for (var x = 0; x <= 61; x++) {
// 				const date = moment().subtract(30, "days").add(x, "days");
// 				for (var i = 0; i <=23; i++) {
// 					const addFillDateTime = date.hours(i).minutes(0).unix();
// 					const randomPrice = Math.floor(Math.random() * (99 - 1) + 1);
// 					const addFillQuery = `INSERT INTO public.fills 
// 					(order_id, outcome, market_id, amount, price, fill_time, owner) 
// 					VALUES 
// 					(${row.id}, ${row.outcome}, ${row.market_id}, ${row.filled}, ${randomPrice}, TO_TIMESTAMP(${addFillDateTime}), '${row.creator}')`
// 					pool.query(addFillQuery, (error, results) => {
// 						if (error) console.log("ERROR", error);
// 					});
// 				}
// 			}
// 		})
		
// 		return res.status(200).json({"success": true});
// 	})
// });


module.exports = router;