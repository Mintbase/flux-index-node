curl -X POST -H "Content-Type: application/json" \
 -d '{"marketId": 0, "accountId": "test.near" }' \
 localhost:3000/market/get_share_balances_for_user
