// TODO: Probably better typing to be used here
use near_primitives::{
    receipt::Receipt,
    transaction::{ExecutionOutcome, ExecutionStatus, SignedTransaction}
};

const FLUX_FUNGIBLE_RECEIVER_ID: String = "FluxFungibleContract".to_string();
const FLUX_PROTOCOL_RECEIVER_ID: String = "FluxProtocolContract".to_string();

pub fn isSuccessfulReceipt(mut receipt: Receipt) -> bool {
    // If receipt status != success, ignore
    return match receipt.outcome.status {
        ExecutionStatus::SuccessValue(_) => true,
        _ => return false
    }
}

pub fn isFluxTransfer(mut transaction: Transaction ) -> bool {
    // If transaction receiver is not a flux contract, ignore
    return match transaction.transaction.receiver_id {
        FLUX_PROTOCOL_RECEIVER_ID => true,
        FLUX_FUNGIBLE_RECEIVER_ID => true,
        _ => false
    }
}

pub async fn processTransfer(mut receipt: Receipt, mut transaction: Transaction) {
    // Is the log going to be the best processing mechanism?
    match receipt.outcome.logs {
        "create market" => createMarketHandler(receipt, transaction).await,
        "create Account" => createAccountHandler(),
        "get Balance" => getBalanceHandler(),
        "place Order" => placeOrderHandler(),
        "set Allowance" => setAllowanceHandler(),
        _ => return
    }
}

async fn createMarketHandler(receipt: Receipt, transaction: Transaction) {
    // Put state in postgres table
    // Return
}

async fn createAccountHandler(receipt: Receipt, transaction: Transaction) {
    // Put state in postgres table
    // Return
}

async fn getBalanceHandler(receipt: Receipt, transaction: Transaction) {
    // Put state in postgres table
    // Return
}

async fn placeOrderHandler(receipt: Receipt, transaction: Transaction) {
    // Put state in postgres table
    // Return
}

async fn setAllowanceHandler(receipt: Receipt, transaction: Transaction) {
    // Put state in postgres table
    // Return
}
