// TODO: Probably better typing to be used here
use near_primitives::{
    receipt::Receipt,
    transaction::{ExecutionOutcome, ExecutionStatus, SignedTransaction},
    views
};
use near_indexer;

const FLUX_FUNGIBLE_RECEIVER_ID: String = "FluxFungibleContract".to_string();
const FLUX_PROTOCOL_RECEIVER_ID: String = "FluxProtocolContract".to_string();


pub fn isValidFluxTransfer(outcome: &near_indexer::streamer::streamer::Outcome ) -> bool {
    match outcome {
        near_indexer::streamer::streamer::Outcome::Receipt(views::ExecutionOutcomeWithIdView) => true,
        _ => return false
    }

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
pub async fn processTransfer(outcome: &near_indexer::streamer::streamer::Outcome) -> bool {
    // Is the log going to be the best processing mechanism?
    return match outcome.outcome.logs.r#type {
        "market_creation" => createMarketHandler(&outcome).await,
        "order_placed" => placeOrderHandler(&outcome).await,
        _ => false
    };
}

async fn createMarketHandler(outcome: &near_indexer::streamer::streamer::Outcome) -> bool{
    println!("creating Market! {:?}", outcome);
    return true;
    // Put state in postgres table
    // Return
}

async fn placeOrderHandler(outcome: &near_indexer::streamer::streamer::Outcome) -> bool {
    println!("order placed! {:?}", outcome);
    return true;
    // Put state in postgres table
    // Return
}

