use postgres::{Client, NoTls, Error};

pub fn read_db() -> Result<(), Error> {
	println!("getting");
	let mut client = Client::connect("host=localhost sslmode=disable user=flux dbname=flux password=flux", NoTls)?;
	
	for row in client.query("SELECT * FROM markets", &[])? {
		println!("");
		let description: String = row.get("description");
		println!("row: {:?}", description);
	};
	
    Ok(())
}

pub fn write_db() -> Result<(), Error> {
	println!("posting");
	let mut client = Client::connect("host=localhost sslmode=disable user=flux dbname=flux password=flux", NoTls)?;

	let added = client.execute("INSERT INTO public.markets(
		id, description, extra_info, creator, creation_date, end_date_time, outcomes, outcome_tags, categories, winning_outcome, resoluted, resolute_bond, filled_volume, disputed, finalized, creator_fee_percentage, resolution_fee_percentage, affiliate_fee_percentage, api_source, validity_bond_claimed)
		VALUES (8, 'test', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla', 'flux-dev', NOW(), '2021-01-01 00:00:00', 2, Array ['boop', 'biep'], Array ['test'], null, false, 5e18, 0, false, false, 1, 1, 50, null , false);
	", &[])?;
	
	println!("get here");
	println!("added {:?}", added);

	Ok(())
}