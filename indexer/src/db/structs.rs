use bigdecimal::BigDecimal;
use std::str::FromStr;
use std::time::SystemTime;
use chrono::{DateTime, NaiveDateTime};
use serde_json::{Value};
use super::schema::*;

fn string_value_to_date(date_val: &Value) -> NaiveDateTime {
    let date_str = date_val.as_str().unwrap().to_string();
    
    let date_int = date_str.parse::<i64>().unwrap();
    println!("dat str  {:?}     {:?}", date_str, NaiveDateTime::from_timestamp(date_int / 1000, 0));
    
    return NaiveDateTime::from_timestamp(date_int / 1000, 0);
}

pub fn val_to_i16(val: &Value) -> i16 {
    let s = val.as_str().unwrap().to_string();
    return s.parse::<i16>().unwrap();
}

pub fn val_to_i64(val: &Value) -> i64 {
    let s = val.as_str().unwrap().to_string();
    return s.parse::<i64>().unwrap();
}

pub fn val_to_opt_i64(val: &Value) -> Option<i64> {
    return match val.as_str() {
        Some(s) => Some(s.to_string().parse::<i64>().unwrap()),
        _ => None
    };
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


#[derive(Insertable, Clone, Debug)]
pub struct Market {
    id: i64,
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

impl Market {

    pub fn from_args(args: &Value) -> Self {
        let creation_date = SystemTime::now();
        let end_date_time = string_value_to_date(&args["end_time"]);

        Self {
            id: val_to_i64(&args["id"]),
            description: args["description"].as_str().unwrap().to_string(),
            extra_info: Some(args["extra_info"].as_str().unwrap().to_string()),
            creator: args["creator"].as_str().unwrap().to_string(),
            creation_date,
            end_date_time,
            outcomes: val_to_i16(&args["outcomes"]),
            outcome_tags: val_vec_to_str(args["outcome_tags"].as_array().unwrap()),
            categories: val_vec_to_str(args["categories"].as_array().unwrap()),
            winning_outcome: None,
            resoluted: false,
            resolute_bond: BigDecimal::from_str((dai_token() * 5).to_string().as_str()).unwrap(),
            filled_volume: BigDecimal::from_str("0").unwrap(),
            disputed: false,
            finalized: false,
            creator_fee_percentage: val_to_i16(&args["creator_fee_percentage"]),
            resolution_fee_percentage: val_to_i16(&args["resolution_fee_percentage"]),
            affiliate_fee_percentage: val_to_i16(&args["affiliate_fee_percentage"]),
            api_source: args["api_source"].as_str().unwrap().to_string(),
            validity_bond_claimed: false,
        }
    }
}


#[derive(Insertable, Clone, Debug)]
pub struct Order {
    id: BigDecimal,
    creator: String,
    outcome: i64,
    market_id: i64,
    spend: BigDecimal,
    shares: BigDecimal,
    price: BigDecimal,
    filled: BigDecimal,
    shares_filled: BigDecimal,
    affiliate_account_id: String,
    creation_time: SystemTime,
    closed: bool
}

impl Order {

    pub fn from_args(args: &Value, log_type: &Value) -> Self {
        let creation_date = SystemTime::now();

        Self {
            id: BigDecimal::from_str(&args["order_id"].as_str().unwrap().to_string()).unwrap(),
            creator: args["account_id"].as_str().unwrap().to_string(),
            outcome: val_to_i64(&args["outcome"]),
            market_id: val_to_i64(&args["market_id"]),
            spend: BigDecimal::from_str(&args["spend"].as_str().unwrap().to_string()).unwrap(),
            shares: BigDecimal::from_str(&args["amt_of_shares"].as_str().unwrap().to_string()).unwrap(),
            price: BigDecimal::from_str(&args["price"].as_str().unwrap().to_string()).unwrap(),
            filled: BigDecimal::from_str(&args["filled"].as_str().unwrap().to_string()).unwrap(),
            shares_filled: BigDecimal::from_str(&args["shares_filled"].as_str().unwrap().to_string()).unwrap(),
            affiliate_account_id: args["affiliate_account_id"].as_str().unwrap().to_string(),
            creation_time: creation_date,
            closed: log_type == &"order_filled_at_placement".to_string(),
        }
    }
}

#[derive(Insertable, Clone, Debug)]
pub struct Fill {
    order_id: BigDecimal,
    market_id: i64,
    outcome: i64,
    amount: BigDecimal,
    fill_time: SystemTime,
    owner: String,
    price: BigDecimal,
    block_height: BigDecimal,
}

impl Fill {
    pub fn from_args(args: &Value) -> Self {
        let creation_date = SystemTime::now();

        Self {
            order_id: BigDecimal::from_str(&args["order_id"].as_str().unwrap().to_string()).unwrap(),
            market_id: val_to_i64(&args["market_id"]),
            outcome: val_to_i64(&args["outcome"]), 
            amount: BigDecimal::from_str(&args["shares_filling"].as_str().unwrap().to_string()).unwrap(),
            fill_time: creation_date,
            owner: args["account_id"].as_str().unwrap().to_string(),
            price: BigDecimal::from_str(&args["price"].as_str().unwrap().to_string()).unwrap(),
            block_height: BigDecimal::from_str(&args["block_height"].as_str().unwrap().to_string()).unwrap(),
        }
    }
}

#[derive(Insertable, Clone, Debug)]
pub struct ClaimableIfValid {
    market_id: i64,
    account_id: String,
    claimable: BigDecimal
}

impl ClaimableIfValid {
    pub fn from_args(args: &Value) -> Self {
        Self {
            claimable: BigDecimal::from_str(&args["claimable_if_valid"].as_str().unwrap().to_string()).unwrap(),
            market_id: val_to_i64(&args["market_id"]),
            account_id: args["sender"].as_str().unwrap().to_string(),
        }
    }
}


#[derive(Insertable, Clone, Debug)]
pub struct ResolutionWindow {
    market_id: i64,
    round: i64,
    bond_size: BigDecimal,
    outcome: Option<i64>,
    end_time: NaiveDateTime
}

impl ResolutionWindow {
    
    pub fn from_args(args: &Value) -> Self {
        let end_date_time = string_value_to_date(&args["end_time"]);

        Self {
            market_id: val_to_i64(&args["market_id"]),
            round: val_to_i64(&args["round"]),
            bond_size: BigDecimal::from_str(&args["required_bond_size"].as_str().unwrap().to_string()).unwrap(),
            outcome: None,
            end_time: end_date_time
        }
    }
}

#[derive(Insertable, Clone, Debug)]
pub struct AccountStakeInOutcome {
    account_id: String,
    market_id: i64,
    outcome: i64,
    round: i64,
    stake: BigDecimal,
}

impl AccountStakeInOutcome {
    pub fn from_args(args: &Value) -> Self {
        Self {
            account_id: args["sender"].as_str().unwrap().to_string(),
            market_id: val_to_i64(&args["market_id"]),
            round: val_to_i64(&args["round"]),
            stake: BigDecimal::from_str(&args["staked"].as_str().unwrap().to_string()).unwrap(),
            outcome: val_to_i64(&args["outcome"]),
        }
    }
}

#[derive(Insertable, Clone, Debug)]
pub struct Account {
    id: String,
    affiliate_earnings: BigDecimal,
}

impl Account {
    pub fn from_args(args: &Value) -> Self {
        Self {
            id: args["affiliate"].as_str().unwrap().to_string(),
            affiliate_earnings: BigDecimal::from_str(&args["earned"].as_str().unwrap().to_string()).unwrap(),
            
        }
    }
}

#[derive(Insertable, Clone, Debug)]
pub struct ClaimedMarket {
    market_id: i64,
    account_id: String,
}

impl ClaimedMarket {
    pub fn from_args(args: &Value) -> Self {
        Self {
            market_id: val_to_i64(&args["market_id"]),
            account_id: args["account_id"].as_str().unwrap().to_string(),
        }
    }
}