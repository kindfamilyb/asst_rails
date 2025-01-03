class BitcoinPriceChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "bitcoin_price_channel" # 채널 스트림

  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
