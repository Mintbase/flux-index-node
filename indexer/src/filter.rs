// TODO: Probably better typing to be used here
use near_primitives::{
    receipt::Receipt,
    transaction::{ExecutionOutcome, ExecutionStatus, SignedTransaction},
    views,
    types
};
use near_indexer::streamer::streamer::Outcome;

const FLUX_FUNGIBLE_RECEIVER_ID: String = "FluxFungibleContract".to_string();
const FLUX_PROTOCOL_RECEIVER_ID: String = "FluxProtocolContract".to_string();


pub fn isValidFluxTransfer(outcome: &Outcome ) -> bool {
    match outcome {
        Outcome::Receipt(views::ExecutionOutcomeWithIdView) => true,
        _ => return false
    };

    match outcome.status {
        ExecutionStatus::SuccessValue(_) => true,
        _ => return false
    };

    match outcome.outcome.receiver_id {
        FLUX_PROTOCOL_RECEIVER_ID => true,
        FLUX_FUNGIBLE_RECEIVER_ID => true,
        _ => return false
    };
    return true;
}

// TODO: Return success value
pub async fn processTransfer(outcome: &Outcome) -> bool {
    // Is the log going to be the best processing mechanism?
    return match outcome.outcome.logs.r#type {
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

