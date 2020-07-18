curl -X POST -H "Content-Type: application/json" \
 -d '{ "filter": {"categories": ["sports", "politics"]} }' \
 localhost:3000/markets/get
