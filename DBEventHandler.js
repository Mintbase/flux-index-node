const events = require("events");

const em = new events.EventEmitter();

const DBEventHandler = data => {
    switch (data.channel) {
        case "update_markets":
            em.emit("UpdateMarkets", data.payload)
            break;
        case "update_orders":
            em.emit("UpdateOrders", data.payload)
            break;
        default:
            console.log("unidentified event found", data.channel)
    }
}

module.exports = DBEventHandler;