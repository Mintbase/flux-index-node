curl -X POST -H "Content-Type: application/json" \
 -d '{"marketId": 0, "accountId": "flux-dev" }' \
 localhost:3000/market/get_open_orders_for_user
