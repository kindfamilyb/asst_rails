// app/javascript/channels/bitcoin_price_channel.js
import consumer from "./consumer";

consumer.subscriptions.create("BitcoinPriceChannel", {
  connected() {
    console.log("Connected to BitcoinPriceChannel");
  },

  disconnected() {
    console.log("Disconnected from BitcoinPriceChannel");
  },

  received(data) {
    console.log("Received data:", data);
    // 가격 데이터를 화면에 반영
    // const priceElement = document.getElementById("bitcoin-price");
    // if (priceElement) {
    //   priceElement.textContent = `₩ ${data.price}`;
    // }
  }
});
