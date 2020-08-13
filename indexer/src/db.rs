use near_indexer::near_primitives::{
    views::{ExecutionOutcomeWithIdView, ExecutionStatusView},
};
use near_indexer::Outcome;
use serde_json::{Result, Value};

use bigdecimal::BigDecimal;
use std::str::FromStr;

use diesel::{
    prelude::*,
    r2d2::{ConnectionManager, Pool},
};
use tokio_diesel::*;

mod schema;
mod structs;

pub fn continue_if_valid_flux_receipt(outcome: Outcome) -> Option<ExecutionOutcomeWithIdView> {

    let receipt: ExecutionOutcomeWithIdView = match outcome {
        Outcome::Receipt(outcome) => outcome,
        _ => return None
    };
    
    if receipt.outcome.executor_id != "12345.test.near" {return None}

    let res = match &receipt.outcome.status {
        ExecutionStatusView::SuccessValue(res) => res,
        _ => return None
    };

    return Some(receipt);
        
}

pub async fn process_logs(pool: &Pool<ConnectionManager<PgConnection>>, receipt: ExecutionOutcomeWithIdView) -> Result<()> {
    
    for log in receipt.outcome.logs {
        let json: Value = serde_json::from_str(log.as_str())?;
        execute_log(pool, &json["type"], &json["params"]).await;
    }

    Ok(())
}

// TODO: batch tx's
pub async fn execute_log(pool: &Pool<ConnectionManager<PgConnection>>, log_type: &Value, params: &Value) {    
	if log_type == &"market_creation".to_string() {
        add_market(pool, params).await;
    } else if log_type == &"order_placed".to_string() || log_type == &"order_filled_at_placement".to_string()  {
        add_order(pool, params, log_type).await;
        
        let filled = params["shares_filling"]
            .as_str()
            .unwrap()
            .to_string()
            .parse::<u128>()
            .unwrap();

        if filled > 0 {
            add_fill(pool, params).await;
        }

    } else if log_type == &"order_filled".to_string() ||log_type == &"order_partly_filled".to_string() {
        add_fill(pool, params).await;
        fill_order(pool, params).await;
    } else if log_type == &"order_closed".to_string() {
        close_order(pool, params).await;
    } else if log_type == &"sold_fill_from_order".to_string() {
        update_order_after_sell(pool, params).await;
    }
}

pub async fn add_market(pool: &Pool<ConnectionManager<PgConnection>>, params: &Value) {
    let market: structs::Market = structs::Market::from_args(params);

    println!("{:?}", market);

    diesel::insert_into(schema::markets::table)
        .values(market)
        .execute_async(pool)
        .await
        .expect("something went wrong while trying to insert into markets");
}

pub async fn add_order(pool: &Pool<ConnectionManager<PgConnection>>, params: &Value, log_type: &Value) {
    let order: structs::Order = structs::Order::from_args(params, log_type);

    println!("{:?}", order);

    diesel::insert_into(schema::orders::table)
        .values(order)
        .execute_async(pool)
        .await
        .expect("something went wrong while trying to insert into orders");
}

pub async fn add_fill(pool: &Pool<ConnectionManager<PgConnection>>, params: &Value) {
    let fill: structs::Fill = structs::Fill::from_args(params);

    diesel::insert_into(schema::fills::table)
        .values(fill)
        .execute_async(pool)
        .await
        .expect("something went wrong while trying to insert into fills");
}

pub async fn update_order_after_sell(pool: &Pool<ConnectionManager<PgConnection>>, params: &Value) {
    let order_id = BigDecimal::from_str(&params["order_id"].as_str().unwrap().to_string()).unwrap();
    let outcome = structs::val_to_i64(&params["outcome"]);
    let market_id = structs::val_to_i64(&params["market_id"]);

    let updated_spend = BigDecimal::from_str(&params["updated_spend"].as_str().unwrap().to_string()).unwrap();
    let updated_filled = BigDecimal::from_str(&params["updated_filled"].as_str().unwrap().to_string()).unwrap();
    let updated_amt_of_shares = BigDecimal::from_str(&params["updated_amt_of_shares"].as_str().unwrap().to_string()).unwrap();
    let updated_shares_filled = BigDecimal::from_str(&params["updated_amt_of_shares"].as_str().unwrap().to_string()).unwrap();


    diesel::update(
        schema::orders::table
            .filter(
                schema::orders::dsl::market_id.eq(market_id).and(schema::orders::dsl::id.eq(order_id)).and(schema::orders::dsl::outcome.eq(outcome))
            )
    )
    .set((
        schema::orders::dsl::spend.eq(updated_spend),
        schema::orders::dsl::filled.eq(updated_filled),
        schema::orders::dsl::shares.eq(updated_amt_of_shares),
        schema::orders::dsl::shares_filled.eq(updated_shares_filled),
    ))
    .execute_async(pool)
    .await
    .expect("filling order failed");
}

pub async fn fill_order(pool: &Pool<ConnectionManager<PgConnection>>, params: &Value) {
    let order_id = BigDecimal::from_str(&params["order_id"].as_str().unwrap().to_string()).unwrap();
    let outcome = structs::val_to_i64(&params["outcome"]);
    let market_id = structs::val_to_i64(&params["market_id"]);
    let filled = BigDecimal::from_str(&params["filled"].as_str().unwrap().to_string()).unwrap();
    let shares_filled = BigDecimal::from_str(&params["shares_filled"].as_str().unwrap().to_string()).unwrap();

    diesel::update(
        schema::orders::table
            .filter(
                schema::orders::dsl::market_id.eq(market_id).and(schema::orders::dsl::id.eq(order_id)).and(schema::orders::dsl::outcome.eq(outcome))
            )
    )
    .set((
        schema::orders::dsl::filled.eq(filled),
        schema::orders::dsl::shares_filled.eq(shares_filled),
    ))
    .execute_async(pool)
    .await
    .expect("filling order failed");
}

pub async fn close_order(pool: &Pool<ConnectionManager<PgConnection>>, params: &Value) {
    let order_id = BigDecimal::from_str(&params["id"].as_str().unwrap().to_string()).unwrap();
    let outcome = structs::val_to_i64(&params["outcome"]);
    let market_id = structs::val_to_i64(&params["market_id"]);

    diesel::update(
        schema::orders::table
            .filter(
                schema::orders::dsl::market_id.eq(market_id).and(schema::orders::dsl::id.eq(order_id)).and(schema::orders::dsl::outcome.eq(outcome))
            )
    )
    .set((
        schema::orders::dsl::closed.eq(true),
    ))
    .execute_async(pool)
    .await
    .expect("canceling order failed");
}