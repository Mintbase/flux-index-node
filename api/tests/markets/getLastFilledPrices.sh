curl -X POST -H "Content-Type: application/json" \
 -d '{"limit": 1, "offset": 1 }' \
 localhost:3000/markets/last_filled_prices

# curl -X POST -H "Content-Type: application/json" \
#  localhost:3000/markets/get