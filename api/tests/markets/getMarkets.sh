curl -X POST -H "Content-Type: application/json" \
 -d '{ "limit": 1, "offset": 0 }' \
 localhost:3000/markets/get

# curl -X POST -H "Content-Type: application/json" \
#  localhost:3000/markets/get