
use serde_json::{Value};
use diesel::{
    prelude::*,
    r2d2::{ConnectionManager, Pool},
};
use std::error::Error;
use tokio_diesel::*;


mod schema;
mod markets;

pub async fn execute_log(pool: &Pool<ConnectionManager<PgConnection>>, log_type: &Value, params: &Value) {
	if log_type == &"market_creation".to_string() {
        add_market(pool, params).await;
    }
}

pub async fn add_market(pool: &Pool<ConnectionManager<PgConnection>>, params: &Value) {
    let market = markets::Market::from_args(params);

    println!("{:?}", market);

    diesel::insert_into(schema::markets::table)
        .values(market)
        .execute_async(pool)
        .await
        .expect("something went wrong while trying to insert into markets");
}