// TODO: Probably better typing to be used here
use near_primitives::{
    receipt::Receipt,
    transaction::{ExecutionOutcome, ExecutionStatus, SignedTransaction}
};

const FLUX_FUNGIBLE_RECEIVER_ID = "FluxFungibleContract";
const FLUX_PROTOCOL_RECEIVER_ID = "FluxProtocolContract";

async fn isSuccessfulReceipt(mut receipt: Receipt) {
    // If receipt status != success, ignore
    match receipt.outcome.status {
        ExecutionStatus::SuccessValue(_),
        _ => return false;
    }
    return true;
}

async fn isFluxTransfer(mut transaction: Transaction ) {
    // If transaction receiver is not a flux contract, ignore
    match transaction.transaction.receiver_id {
        FLUX_PROTOCOL_RECEIVER_ID,
        FLUX_FUNGIBLE_RECEIVER_ID,
        _ => return false;
    }
    return true;
}

async fn processTransfer(mut receipt: Receipt, mut transaction: Transaction) {
    // Is the log going to be the best processing mechanism?
    match receipt.outcome.logs {
        "create market" => createMarketHandler(receipt, transaction);
        _ => return;
    }
}

async fn createMarketHandler(receipt, transaction) {
    // Put state in postgres table
    // Return
}
