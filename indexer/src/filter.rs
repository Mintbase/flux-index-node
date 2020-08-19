// TODO: Probably better typing to be used here
use near_indexer::near_primitives::{
    views::{ExecutionOutcomeWithIdView, ExecutionStatusView},
};
use near_indexer::Outcome;

// const FLUX_FUNGIBLE_RECEIVER_ID: String = "FluxFungibleContract".to_string();
// const FLUX_PROTOCOL_RECEIVER_ID: String = "FluxProtocolContract".to_string();


pub fn isValidFluxTransfer(outcome: &Outcome ) -> bool {

    let receipt: &ExecutionOutcomeWithIdView = match outcome {
        Outcome::Receipt(outcome) => outcome,
        _ => return false
    };

    if receipt.outcome.executor_id != "flux_protocol.test.near" {return false}

    let res = match &receipt.outcome.status {
        ExecutionStatusView::SuccessValue(res) => res,
        _ => return false
    };

    return true;
}

// // TODO: Return success value
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
//     // Put state in postgres table
//     // Return
// }

