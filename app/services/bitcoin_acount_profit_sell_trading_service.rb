require 'jwt'
require 'securerandom'

class BitcoinAccountProfitSellTradingService
  def initialize(user_id)
    @user_id = user_id
    @upbit_service = UpbitService.new
  end

  def execute_trading
    # 현재 유저의 활성화된 전략 정보 가져오기
    strategy = MyStrategyInfo.find_by(
      user_id: @user_id,
      strategy_id: 1,
      is_active: true
    )

    return unless strategy

    # Upbit 수익률 계산
    btc_profit = calculate_btc_profit
    
    # 마지막 매도 시간 확인
    last_sell = LastSellRecord.find_by(user_id: @user_id)
    today = Date.today

    # 전략의 signal_number와 비트코인 수익률이 같고, 오늘 매도하지 않았다면 매도 실행
    if strategy.signal_number == btc_profit && (!last_sell || last_sell.sold_at.to_date < today)
      execute_sell
      
      # 매도 기록 업데이트
      if last_sell
        last_sell.update(sold_at: Time.current)
      else
        LastSellRecord.create(user_id: @user_id, sold_at: Time.current)
      end
    end
  end

  private

  def calculate_account_profit
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
      return ((current_price - avg_buy_price) / avg_buy_price * 100).round
    end    
  end

  def execute_sell
    @upbit_service.sell_market_order('BTC')
  end
end