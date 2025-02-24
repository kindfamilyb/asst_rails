// // import consumer from "channels/consumer"

// consumer.subscriptions.create("BitcoinPriceChannel", {
//   connected() {
//     // Called when the subscription is ready for use on the server
//     console.log("Connected to UpbitChannel");

//   },

//   disconnected() {
//     // Called when the subscription has been terminated by the server
//     console.log("Disconnected from UpbitChannel");

//   },

//   received(data) {
//     // Called when there's incoming data on the websocket for this channel
//     // 서버에서 broadcast("upbit_channel", { price: ... }) 시 받은 데이터
//     console.log("Received data:", data);
//     // 예: <span id="btc_price">태그의 텍스트를 업데이트
//     const priceElement = document.getElementById("bitcoin-price");
//     if (priceElement && data.price) {
//       priceElement.textContent = data.price;
//     }
//   }
// });
