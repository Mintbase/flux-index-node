
use serde_json::{Value};
use diesel::{
    prelude::*,
    r2d2::{ConnectionManager, Pool},
};
use std::error::Error;
use tokio_diesel::*;
use bigdecimal::BigDecimal;
use schema::markets;
use chrono::{DateTime, NaiveDateTime};
use std::str::FromStr;
use std::time::SystemTime;

mod schema;

// table! {
//     use diesel::sql_types::*;
//     markets (id, description, extra_info, creator, creation_date, end_date_time, outcomes, outcome_tags, categories, winning_outcome, resoluted, resolute_bond, filled_volume, disputed, finalized, creator_fee_percentage, resolution_fee_percentage, affiliate_fee_percentage, api_source, validity_bond_claimed) {
//         id -> Numeric, 
//         description, extra_info, creator, creation_date, end_date_time, outcomes, outcome_tags, categories, winning_outcome, resoluted, resolute_bond, filled_volume, disputed, finalized, creator_fee_percentage, resolution_fee_percentage, affiliate_fee_percentage, api_source, validity_bond_claimed
//     }
// }

#[derive(Insertable, Clone, Debug)]
struct Market {
    id: BigDecimal,
    description: String,
    extra_info: Option<String>,
    creator: String,
    creation_date: SystemTime,
    end_date_time: NaiveDateTime,
    outcomes: i16,
    outcome_tags: Vec<String>,
    categories: Vec<String>,
    winning_outcome: Option<i16>,
    resoluted: bool,
    resolute_bond: BigDecimal,
    filled_volume: BigDecimal,
    disputed: bool,
    finalized: bool,
    creator_fee_percentage: i16,
    resolution_fee_percentage: i16,
    affiliate_fee_percentage: i16,
    api_source: String,
    validity_bond_claimed: bool,
}

fn string_value_to_date(date_val: &Value) -> NaiveDateTime {
    let date_str = date_val.as_str().unwrap().to_string();
    println!("dat str  {:?}", date_str);

    let date_int = date_str.parse::<i64>().unwrap();

    return NaiveDateTime::from_timestamp(date_int / 1000, 0);
}

fn val_to_i64(val: &Value) -> i16 {
    let s = val.as_str().unwrap().to_string();
    return s.parse::<i16>().unwrap();
}

fn val_vec_to_str(val_vec: &Vec<Value>) -> Vec<String> {
    let mut str_vec: Vec<String> = vec![];

    for val in val_vec {
        str_vec.push(val.as_str().unwrap().to_string());
    }

    return str_vec;
}

fn dai_token() -> u128 {
    let base: u128 = 10;
    return base.pow(18)
}


impl Market {

    pub fn from_args(args: &Value) -> Self {
        println!("asdasd {:?} ", &args["id"].as_str());
        println!("asdasd {:?} ", &args["id"].as_str());
        println!("asdasd {:?} ", &args["id"].as_str());

        println!("{:?} ", args);

        let creation_date = SystemTime::now();
        let end_date_time = string_value_to_date(&args["end_time"]);

        Self {
            id: BigDecimal::from_str(&args["id"].as_i64().unwrap().to_string()).unwrap(),
            description: args["description"].as_str().unwrap().to_string(),
            extra_info: Some(args["extra_info"].as_str().unwrap().to_string()),
            creator: args["creator"].as_str().unwrap().to_string(),
            creation_date,
            end_date_time,
            outcomes: val_to_i64(&args["outcomes"]),
            outcome_tags: val_vec_to_str(args["outcome_tags"].as_array().unwrap()),
            categories: val_vec_to_str(args["categories"].as_array().unwrap()),
            winning_outcome: None,
            resoluted: false,
            resolute_bond: BigDecimal::from_str((dai_token() * 5).to_string().as_str()).unwrap(),
            filled_volume: BigDecimal::from_str("0").unwrap(),
            disputed: false,
            finalized: false,
            creator_fee_percentage: val_to_i64(&args["creator_fee_percentage"]),
            resolution_fee_percentage: val_to_i64(&args["resolution_fee_percentage"]),
            affiliate_fee_percentage: val_to_i64(&args["affiliate_fee_percentage"]),
            api_source: args["api_source"].as_str().unwrap().to_string(),
            validity_bond_claimed: false,
        }
    }
}

pub async fn execute_log(pool: &Pool<ConnectionManager<PgConnection>>, log_type: &Value, params: &Value) {
	if log_type == &"market_creation".to_string() {
        add_market(pool, params).await;
    }
}

pub async fn add_market(pool: &Pool<ConnectionManager<PgConnection>>, params: &Value) {
    let market = Market::from_args(params);

    println!("{:?}", market);

    diesel::insert_into(schema::markets::table)
        .values(market)
        .execute_async(pool)
        .await
        .expect("something went wrong while trying to insert into markets");
}