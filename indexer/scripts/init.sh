bash ./scripts/createAccount.sh flux-dev
bash ./scripts/createAccount.sh $1
bash ./scripts/createAccount.sh $2

bash ./scripts/deployContract.sh $3 $1
bash ./scripts/deployContract.sh $4 $2
bash ./scripts/initFunToken.sh $2