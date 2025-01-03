# app/jobs/fetch_upbit_price_job.rb
require 'net/http'
require 'uri'
require 'json'

class FetchUpbitPriceJob < ApplicationJob
  # redis 서비스 이용해서 가격 업데이트 ( 현재는 필요없음 : 브로드캐스트 이용해서 가격 업데이트 해야함 )
  queue_as :default

  def perform(market = "KRW-BTC")
    price = fetch_price_from_upbit(market)
    if price
      ActionCable.server.broadcast("bitcoin_price_channel", { price: price })
    end
  end

  private

  def fetch_price_from_upbit(market)
    uri = URI("https://api.upbit.com/v1/ticker?markets=#{market}")
    response = Net::HTTP.get(uri)
    result = JSON.parse(response)
    
    # API 응답 형태 예: [{ "market":"KRW-BTC", "trade_price":... }]
    current_bitcoin_redis_price = result.first["trade_price"] rescue nil
    RedisService.set('current_bitcoin_redis_price', current_bitcoin_redis_price)
    
    # 처리 안되고 있음 이유 찾아야함
    ActionCable.server.broadcast("bitcoin_price_channel", { price: current_bitcoin_redis_price })

    current_bitcoin_redis_price
    puts RedisService.get('current_bitcoin_redis_price')
  end
end
