bash ./scripts/createMarket.sh $1
bash ./scripts/placeOrderAffiliate.sh $1 $2 0
bash ./scripts/placeOrderAffiliate.sh $1 $2 1
bash ./scripts/resoluteMarket.sh $1 $2
bash ./scripts/finalizeMarket.sh $1 $2
bash ./scripts/claimEarnings.sh $1 $2