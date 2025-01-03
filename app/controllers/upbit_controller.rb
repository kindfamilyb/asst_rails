require 'jwt'
require 'securerandom'

class UpbitController < ApplicationController
  before_action :bitcoin_price
  before_action :authenticate_user!


  def index
    
  end

  def bitcoin_price
    url = "https://api.upbit.com/v1/ticker?markets=KRW-BTC"
    response = HTTParty.get(url)
    
    puts response

    if response.code == 200
      ticker_data = response.parsed_response.first
      @bitcoin_price = {
        market: ticker_data['market'],              # 거래 시장 (예: KRW-BTC)
        trade_price: ticker_data['trade_price'],    # 현재 거래 가격
        high_price: ticker_data['high_price'],      # 고가
        low_price: ticker_data['low_price'],        # 저가
        timestamp: Time.at(ticker_data['timestamp'] / 1000) # 데이터 시간
      }

      @btc_price = @bitcoin_price[:trade_price]
    else
      @error = "Failed to fetch Bitcoin price data: #{response.code}"
    end
  end


  def accounts
    access_key = Rails.application.credentials.dig(:upbit, :access_key)
    secret_key = Rails.application.credentials.dig(:upbit, :secret_key)

    nonce = SecureRandom.uuid
    payload = {
      access_key: access_key,
      nonce: nonce
    }

    jwt_token = JWT.encode(payload, secret_key, 'HS256')

    url = "https://api.upbit.com/v1/accounts"
    headers = { "Authorization" => "Bearer #{jwt_token}" }

    response = HTTParty.get(url, headers: headers)
    @current_bitcoin_redis_price = RedisService.get('current_bitcoin_redis_price')

    if response.code == 200
      accounts = response.parsed_response
      @krw_account = accounts.select { |a| a["currency"] == "KRW" }
      @krw_balance = @krw_account.map { |a| a["balance"] }[0].to_i

      @btc_account = accounts.select { |a| a["currency"] == "BTC" }
      @btc_balance = @btc_account.map { |a| a["balance"] }[0]
      @btc_avg_buy_price = @btc_account.map { |a| a["avg_buy_price"] }[0]
      @btc_currency = @btc_account.map { |a| a["currency"] }[0]
      
      # 매수 금액 계산
      @btc_buy_value = @btc_balance.to_f * @btc_avg_buy_price.to_f

      # 현재 평가금액 계산 balance * bitcoin_currnet_price
      @btc_currnet_value = @btc_balance.to_f * @bitcoin_price[:trade_price]

      # # 수익률 계산 (매수 금액이 0이 아닌 경우에만)
      @btc_profit_rate = @btc_buy_value - @btc_currnet_value  != 0 ? (((@btc_currnet_value - @btc_buy_value) / @btc_buy_value) * 100).round(2) : 0
    end
  end

  # 로그인 여부 확인 후 root로 이동시키는 메소드
  def redirect_unless_logged_in
    unless user_signed_in?
      redirect_to root_path, alert: "로그인이 필요합니다."
    end
  end

end
