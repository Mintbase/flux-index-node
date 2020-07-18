# curl -X POST -H "Content-Type: application/json" \
#  -d '{"marketId": 2, "startDate": "2020-07-10", "endDate": "2020-07-18", "dateMetric": "day" }' \
#  localhost:3000/history/get_avg_price_per_date_metric

curl -X POST -H "Content-Type: application/json" \
 -d '{"marketId": 2, "startDate": "2020-07-10", "endDate": "2020-07-11", "dateMetric": "hour" }' \
 localhost:3000/history/get_avg_price_per_date_metric
