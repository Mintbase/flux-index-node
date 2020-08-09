env NEAR_ENV=local near deploy --wasmFile $1 --accountId $2.test.near --masterAccount flux-dev.test.near --initFunction init --initArgs '{"fun_token_account_id": "'$3'.test.near"}'
