const DBEventHandler = (socket, data) => {
    switch (data.channel) {
        // TODO: JSON parse payload
        case "update_markets":
            socket.broadcast.emit("UpdateMarkets", JSON.parse(data.payload))
            break;
        case "update_orders":
            socket.broadcast.emit("UpdateOrders", JSON.parse(data.payload))
            break;
        default:
            console.log("unidentified event found", data.channel)
    }

}

module.exports = DBEventHandler;