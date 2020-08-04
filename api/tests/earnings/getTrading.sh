curl -X POST -H "Content-Type: application/json" \
 -d '{"accountId": "flux-dev", "marketId": 0}' \
 localhost:3000/earnings/get_trading_earnings
