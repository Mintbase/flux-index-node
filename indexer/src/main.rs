// Toy implementation based off the API defined here: https://docs.near.org/docs/interaction/rpc#transaction-status
use std::env;
use std::io;

use actix;

use tokio::sync::mpsc;
use tracing_subscriber::filter::LevelFilter;
use tracing_subscriber::EnvFilter;

use near_sdk::{collections::{UnorderedMap,}}
use near_primitives::{
    receipt::Receipt,
    transaction::{ExecutionOutcome, ExecutionStatus, SignedTransaction}
};

mod filter;

let mut receiptMap: UnorderedMap<String, Receipt> = UnorderedMap::new(b"receipts".to_vec());

use near_indexer;

async fn listen_blocks(mut stream: mpsc::Receiver<near_indexer::BlockResponse>) {
    while let Some(block) = stream.recv().await {
        for chunk in block.chunks {
            // 1) Add receipts into hashMap
            for receipt in chunk.receipts {
                if filter::isSuccessfulReceipt(receipt) {
                    receiptMap.insert(receipt.id, &receipt)
                }
            }

            // 2) Iterate through searching for successful transactions
            for transaction in chunk.transactions {
                if filter::isFluxTransfer(transaction) {
                    for receipt in transaction.transaction_outcomes {
                        let receipt = receiptMap.get(&receipt).expect("receipt doesn't exist");
                        // Means transaction is successful (as dictated by receiptMap)
                        filter::processTransfer(receipt, transaction);
                    }
                };
            }

            //println!("txs {:?}", chunk.transactions);
            //println!("receipts {:?}", chunk.receipts);
        }
    }
}

fn main() {
    let home_dir: Option<String> = env::args().nth(1);

    // init_logging(true);
    let indexer = near_indexer::Indexer::new(home_dir.as_ref().map(AsRef::as_ref));
    let stream = indexer.streamer();
    actix::spawn(listen_blocks(stream));
    indexer.start();
}
