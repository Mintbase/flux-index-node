use std::env;
use std::io;
use actix;
use clap::derive::Clap;
use tokio::sync::mpsc;
use tokio_postgres::{NoTls, Error};
use configs::{init_logging, Opts, SubCommand};

mod configs;
mod utils;


use near_indexer;

pub async fn db_connect() -> Result<tokio_postgres::Client, Error> {
	let (client, connection) =
	tokio_postgres::connect("host=localhost user=flux password=flux", NoTls).await?;

	tokio::spawn(async move {
		if let Err(e) = connection.await {
			eprintln!("connection error: {}", e);
		}
	});

	Ok(client)
}

async fn listen_blocks(mut stream: mpsc::Receiver<near_indexer::BlockResponse>) {
    let mut client = match db_connect().await {
        Ok(client) => client,
        _ => return
    };

    while let Some(block) = stream.recv().await {
        for outcome in block.outcomes {
            utils::continue_if_valid_flux_receipt(outcome, &mut client).await;
        }
    }
}

fn main() {
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
