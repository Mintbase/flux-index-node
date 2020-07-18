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
	console.log(startDate, endDate)
  pool.query(query, values, (error, results) => {
    if (error) {
      console.error(error)
      res.status(404).json(error)
		}

		// console.log(results)
    res.status(200).json(results.rows);
	})
}); 

