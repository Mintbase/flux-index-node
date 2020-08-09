// TODO: Probably better typing to be used here
use near_primitives::{
    receipt::Receipt,
    transaction::{ExecutionOutcome, ExecutionStatus, SignedTransaction},
    views,
    types
};
use near_indexer::Outcome;

const FLUX_FUNGIBLE_RECEIVER_ID: String = "FluxFungibleContract".to_string();
const FLUX_PROTOCOL_RECEIVER_ID: String = "FluxProtocolContract".to_string();


pub fn isValidFluxTransfer(outcome: &Outcome ) -> bool {
    let filtered_outcome: &Receipt = match outcome {
        // Match a single value
        Receipt => Receipt(outcome),
        _ => return false
    };

    let final_outcome: &view::ExecutionOutcomeWithIdView = match filtered_outcome {
        ExecutionOutcomeWithIdView => ExecutionOutcomeWithIdView(filtered_outcome),
        _ => return false
    };

    match final_outcome.status {
        ExecutionStatus::SuccessValue(_) => true,
        _ => return false
    };

    match final_outcome.outcome.receiver_id {
        FLUX_PROTOCOL_RECEIVER_ID => true,
        FLUX_FUNGIBLE_RECEIVER_ID => true,
        _ => return false
    };
    return true;
}

// TODO: Return success value
pub async fn processTransfer(outcome: &Outcome) -> bool {
    // Is the log going to be the best processing mechanism?
    return match outcome.receipt.logs.r#type {
        "market_creation" => createMarketHandler(&outcome).await,
        "order_placed" => placeOrderHandler(&outcome).await,
        _ => false
    };
}

async fn createMarketHandler(outcome: &Outcome) -> bool{
    println!("creating Market! {:?}", outcome);
    return true;
    // Put state in postgres table
    // Return
}

async fn placeOrderHandler(outcome: &Outcome) -> bool {
    println!("order placed! {:?}", outcome);
    return true;
    // Put state in postgres table
    // Return
}

