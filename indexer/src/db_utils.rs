use postgres::{Client, NoTls, Error};

pub fn main() -> Result<(), Error> {
	let mut client = Client::connect("host=localhost sslmode=disable user=flux dbname=flux password=flux", NoTls)?;

	for row in client.query("SELECT * FROM markets", &[])? {
		println!("");
		let description: String = row.get("description");
		println!("row: {:?}", description);

	};

    Ok(())
}