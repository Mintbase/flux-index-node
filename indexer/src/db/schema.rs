table! {
    use diesel::sql_types::*;
	markets (
		id, 
		description, 
		extra_info, 
		creator, 
		creation_date, 
		end_date_time, 
		outcomes, 
		outcome_tags, 
		categories, 
		winning_outcome, 
		resoluted, 
		resolute_bond, 
		filled_volume, 
		disputed, 
		finalized, 
		creator_fee_percentage, 
		resolution_fee_percentage, 
		affiliate_fee_percentage, 
		api_source, 
		validity_bond_claimed
	) {
		id -> Bigint,
		description -> Text,
		extra_info -> Text,
		creator -> Text,
		creation_date -> Timestamp,
		end_date_time -> Timestamp,
		outcomes -> SmallInt,
		outcome_tags -> Array<Text>,
		categories -> Array<Text>,
		winning_outcome -> SmallInt,
		resoluted -> Bool,
		resolute_bond -> Numeric,
		filled_volume -> Numeric,
		disputed -> Bool,
		finalized -> Bool,
		creator_fee_percentage-> SmallInt,
		resolution_fee_percentage-> SmallInt,
		affiliate_fee_percentage-> SmallInt,
		api_source-> Text,
		validity_bond_claimed -> Bool,
	}
}

table!{
	orders (
		id, 
		creator, 
		outcome, 
		market_id, 
		spend, 
		shares, 
		price,
		filled, 
		shares_filled, 
		affiliate_account_id, 
		creation_time, 
	) {
		id -> Numeric,
		creator -> Text,
		outcome -> BigInt,
		market_id -> Bigint,
		spend -> Numeric,
		shares -> Numeric,
		price -> Numeric,
		filled -> Numeric,
		shares_filled -> Numeric,
		affiliate_account_id -> Text,
		creation_time -> Timestamp,
		closed -> Bool,
    }
}

table!{
	fills (
		order_id, 
		market_id, 
		outcome, 
		amount, 
		fill_time, 
		owner, 
		price,
		block_height
	) {
		order_id -> Numeric,
		market_id -> BigInt,
		outcome -> BigInt,
		amount -> Numeric,
		fill_time -> Timestamp,
		owner -> Text,
		price -> Numeric,
		block_height -> Numeric,
    }
}

table!{
	resolution_windows (
		market_id,
		round,
		bond_size,
		outcome,
		end_time,
	) {
		market_id -> BigInt,
		round -> BigInt,
		bond_size -> Numeric,
		outcome -> BigInt,
		end_time -> Timestamp,
	}
}

table!{
	claimable_if_valids (
		account_id,
		market_id,
		claimable
	) {
		account_id -> Text,
		market_id -> BigInt,
		claimable -> Numeric,
    }
}

table!{
	account_stake_in_outcomes (
		account_id,
		market_id,
		outcome,
		stake,
		round
	) {
		account_id -> Text,
		market_id -> BigInt,
		outcome -> BigInt,
		stake -> Numeric,
		round -> BigInt,
    }
}

table!{
	accounts (
		id,
		affiliate_earnings
	) {
		id -> Text,
		affiliate_earnings -> Numeric,
    }
}

table!{
	claimed_markets (
		market_id,
		account_id
	) {
		market_id -> BigInt,
		account_id -> Text,
    }
}

table!{
	account_share_balances (
		market_id,
		account_id,
		outcome,
		balance,
		to_spend,
		spent
	) {
		market_id -> BigInt,
		account_id -> Text,
		outcome -> BigInt,
		balance -> Numeric,
		to_spend -> Numeric,
		spent -> Numeric,
    }
}