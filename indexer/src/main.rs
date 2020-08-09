// Toy implementation based off the API defined here: https://docs.near.org/docs/interaction/rpc#transaction-status
use std::env;
use std::io;
use actix;
use clap::derive::Clap;
use tokio::sync::mpsc;
//use near_sdk::{collections::{UnorderedMap}};
//use near_primitives::{
//    receipt::Receipt,
//    transaction::{ExecutionOutcome, ExecutionStatus, SignedTransaction}
//};
use configs::{init_logging, Opts, SubCommand};

mod filter;
mod configs;
mod db_utils;

//const receiptMap: UnorderedMap<String, receipt: Receipt> = UnorderedMap::new(b"receipts".to_vec());

use near_indexer;

async fn listen_blocks(mut stream: mpsc::Receiver<near_indexer::BlockResponse>) {
    // db_utils::connect();

    while let Some(block) = stream.recv().await {
        for outcome in block.outcomes {
            if filter::isValidFluxTransfer(&outcome) {
                // if !(filter::processTransfer(&outcome).await) {
                //     println!("Error processing transfer");
                // }
            }
        }
    }
}

fn main() {
    // We use it to automatically search the for root certificates to perform HTTPS calls
    // (sending telemetry and downloading genesis)
    openssl_probe::init_ssl_cert_env_vars();

    let opts: Opts = Opts::parse();

    let home_dir =
        opts.home_dir.unwrap_or(std::path::PathBuf::from(near_indexer::get_default_home()));

    match opts.subcmd {
        SubCommand::Run => {
            let indexer = near_indexer::Indexer::new(Some(&home_dir));
            let stream = indexer.streamer();
            actix::spawn(listen_blocks(stream));
            indexer.start();
        }
        SubCommand::Init(config) => near_indexer::init_configs(
            &home_dir,
            config.chain_id.as_ref().map(AsRef::as_ref),
            config.account_id.as_ref().map(AsRef::as_ref),
            config.test_seed.as_ref().map(AsRef::as_ref),
            config.num_shards,
            config.fast,
            config.genesis.as_ref().map(AsRef::as_ref),
            config.download,
            config.download_genesis_url.as_ref().map(AsRef::as_ref),
        ),
    }
}
