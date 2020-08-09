use postgres::{Client, NoTls};

struct DbUtils {
	client: Client
}

// impl DbUtils {

// 	pub fn connect(self) {
// 		let mut client = Client::connect("host=localhost user=flux password=flux", NoTls)?;
// 		println!("{:?}", client);
// 		println!("this is logging");
// 	}
// }
