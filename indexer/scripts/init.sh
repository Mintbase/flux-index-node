# Arg1 = {PROTOCOL_ACCOUNT_ID}
# Arg2 = {FUNTOKEN_ACCOUNT_ID}

echo "creating protocol account..."
bash ./scripts/createAccount.sh $1
echo ""
echo "creating fungible token account..."
bash ./scripts/createAccount.sh $2
echo ""

echo "deploying protocol contract..."
bash ./scripts/deployProtocolContract.sh wasm/flux_protocol.wasm $1 $2
echo ""
echo "deploying fungible token contract..."
bash ./scripts/deployFunTokenContract.sh wasm/fungible_token.wasm $2
echo ""

echo "initializing fungible token contract..."
bash ./scripts/initFunToken.sh $2
echo ""

echo "setting allowance..."
bash ./scripts/setAllowance.sh $2 $1
echo ""

echo "creating market with id 0..."
bash ./scripts/createMarket.sh $1
echo ""
