use std::env;
use std::io;

use actix;

use tokio::sync::mpsc;
use tracing_subscriber::filter::LevelFilter;
use tracing_subscriber::EnvFilter;

use near_indexer;

async fn listen_blocks(mut stream: mpsc::Receiver<near_indexer::BlockResponse>) {
    while let Some(block) = stream.recv().await {
        for chunk in block.chunks {
            println!("txs {:?}", chunk.transactions);
            println!("receipts {:?}", chunk.receipts);

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
