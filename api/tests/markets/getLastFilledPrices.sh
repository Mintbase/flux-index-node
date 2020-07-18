curl -X POST -H "Content-Type: application/json" \
 -d '{ "filter": {"categories": ["sports"]} }' \
 localhost:3000/markets/last_filled_prices
