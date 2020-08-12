use near_indexer::near_primitives::{
    views::{ExecutionOutcomeWithIdView, ExecutionStatusView},
};
use near_indexer::Outcome;
use serde_json::{Result, Value};

use diesel::{
    prelude::*,
    r2d2::{ConnectionManager, Pool},
};

mod db_utils;
// const FLUX_FUNGIBLE_RECEIVER_ID: String = "FluxFungibleContract".to_string();
// const FLUX_PROTOCOL_RECEIVER_ID: String = "FluxProtocolContract".to_string();

pub fn continue_if_valid_flux_receipt(outcome: Outcome) -> Option<ExecutionOutcomeWithIdView> {

    let receipt: ExecutionOutcomeWithIdView = match outcome {
        Outcome::Receipt(outcome) => outcome,
        _ => return None
    };
    
    if receipt.outcome.executor_id != "flux_protocol.test.near" {return None}

    let res = match &receipt.outcome.status {
        ExecutionStatusView::SuccessValue(res) => res,
        _ => return None
    };

    return Some(receipt);
        
}

pub async fn process_logs(pool: &Pool<ConnectionManager<PgConnection>>, receipt: ExecutionOutcomeWithIdView) -> Result<()> {
    
    for log in receipt.outcome.logs {
        let json: Value = serde_json::from_str(log.as_str())?;
        db_utils::execute_log(pool, &json["type"], &json["params"]).await;
    }

    Ok(())
}

// // TODO: Return success value
// pub async fn processTransfer(outcome: &Outcome) -> bool {
//     // Is the log going to be the best processing mechanism?
//     return match outcome.receipt.logs.r#type {
//         "market_creation" => createMarketHandler(&outcome).await,
//         "order_placed" => placeOrderHandler(&outcome).await,
//         _ => false
//     };
// }

// async fn createMarketHandler(outcome: &Outcome) -> bool{
//     println!("creating Market! {:?}", outcome);
//     return true;
//     // Put state in postgres table
//     // Return
// }

// async fn placeOrderHandler(outcome: &Outcome) -> bool {
//     println!("order placed! {:?}", outcome);
//     return true;
//     // Put state in postgres table
//     // Return
// }

