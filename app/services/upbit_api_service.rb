require 'httparty'
require 'jwt'
require 'securerandom'
require 'digest'

class UpbitApiService
  BASE_URL = 'https://api.upbit.com/v1'

  def initialize
    # 1번 전략을 선택한 활성화된 MyStrategyInfo 리스트
    @my_strategy_infos = MyStrategyInfo.where(strategy_id: 1, active_yn: 'Y')

    @access_key = Rails.application.credentials.dig(:upbit, :access_key)
    @secret_key = Rails.application.credentials.dig(:upbit, :secret_key)
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

      @btc_current_price = @bitcoin_price[:trade_price]
    else
      @error = "Failed to fetch Bitcoin price data: #{response.code}"
    end
  end

  # 계좌 정보 조회
  def get_accounts(access_key, secret_key)
    url = "#{BASE_URL}/accounts"
    headers = generate_headers_with_keys(access_key, secret_key)
    response = HTTParty.get(url, headers: headers)
    handle_response(response)
  end


  # 현재 수익률 조회
  def get_current_profit_rate(access_key, secret_key)
    bitcoin_price # 현재 비트코인 가격 업데이트

    accounts = get_accounts(access_key, secret_key)
    krw_account = accounts.select { |a| a["currency"] == "KRW" }
    krw_balance = krw_account.map { |a| a["balance"] }[0].to_i

    btc_account = accounts.select { |a| a["currency"] == "BTC" }
    btc_balance = btc_account.map { |a| a["balance"] }[0]
    btc_avg_buy_price = btc_account.map { |a| a["avg_buy_price"] }[0]
    btc_currency = btc_account.map { |a| a["currency"] }[0]

    # 매수 금액 계산
    btc_buy_value = btc_balance.to_f * btc_avg_buy_price.to_f

    # 현재 평가금액 계산 balance * bitcoin_currnet_price
    btc_currnet_value = btc_balance.to_f * @btc_current_price

    # 수익률 계산 (매수 금액이 0이 아닌 경우에만)
    btc_profit_rate = btc_buy_value - btc_currnet_value != 0 ? (((btc_currnet_value - btc_buy_value) / btc_buy_value) * 100).round(2) : 0
    btc_profit_rate
  end

  # 시장가 매도 주문
  def sell_market_order(market, percentage, volume, access_key, secret_key, my_strategy_info_id, profit_rate)
    # 오늘 같은 전략으로 이번주에 매도한 거래내역이 있다면 이미 매수한 주문이 있다는 메시지 전달후 종료
    today = Date.today
    if Trade.where(my_strategy_info_id: my_strategy_info_id, sold: true, created_at: today.beginning_of_week..today.end_of_week).exists?
      puts "이번주에 같은 전략으로 매도한 거래내역이 있습니다."
      return
    end
    
    url = "#{BASE_URL}/orders"
    body = {
      market: market,      # 예: 'KRW-BTC'
      side: 'ask',         # 매도는 'ask'
      volume: format('%.8f', volume), # 매도 수량
      ord_type: 'market'   # 시장가 주문
    }

    headers = generate_headers_with_keys(access_key, secret_key, body)
    response = HTTParty.post(url, headers: headers, body: body.to_json)
    order_result = handle_response(response)

    puts order_result

    # Trade 테이블에 매도 내역 저장
    strategy_info = MyStrategyInfo.find(my_strategy_info_id)
    # calculate_total_profit_rate의 50% 수익금을 계산 
    profit = calculate_total_profit_rate(access_key, secret_key) * (percentage / 100.0)
    
    Trade.create(
      coin_symbol: market,  # 'KRW-BTC'에서 'BTC' 추출
      sold: true,
      user_id: strategy_info.user_id,
      my_strategy_info_id: my_strategy_info_id,
      volume: volume,                        # 매도 수량
      remaining_volume: 0,                    # 시장가 매도는 즉시 체결되므로 남은 수량은 0
      profit: profit,
      profit_rate: profit_rate
    )
    
    puts "매도 거래 기록 저장 완료"
  end

  

  # 현재 보유량의 지정된 비율만큼 매도
  def sell_percentage_of_balance(market, percentage, access_key, secret_key, my_strategy_info_id, profit_rate)
    # 퍼센트 값 검증
    today = Date.today
    if Trade.where(my_strategy_info_id: my_strategy_info_id, sold: true, created_at: today.beginning_of_week..today.end_of_week).exists?
      puts "이번주에 같은 전략으로 매도한 거래내역이 있습니다."
      return
    end

    raise "Percentage must be between 0 and 100" unless percentage.between?(0, 100)
    
    accounts = get_accounts(access_key, secret_key)
    currency = market.split('-').last # 'KRW-BTC'에서 'BTC' 추출
    account = accounts.find { |a| a['currency'] == currency }
    raise "No balance found for #{currency}" if account.nil?

    balance = account['balance'].to_f
    sell_amount = balance * (percentage / 100.0)
    puts "총 보유량: #{balance}"
    puts "매도 수량: #{sell_amount} (#{percentage}%)"

    sell_market_order(market, percentage, sell_amount, access_key, secret_key, my_strategy_info_id, profit_rate)
    
    puts "#{percentage}% 매도 요청 완료"
  end


  def buy_market_order(market, krw_balance, access_key, secret_key, my_strategy_info_id, profit_rate)
      # 오늘 같은 전략으로 이번주에 매도한 거래내역이 있다면 이미 매수한 주문이 있다는 메시지 전달후 종료
      today = Date.today
      if Trade.where(my_strategy_info_id: my_strategy_info_id, sold: false, created_at: today.beginning_of_week..today.end_of_week).exists?
        puts "이번주에 같은 전략으로 매수한 거래내역이 있습니다."
        return
      end

      url = "#{BASE_URL}/orders"
      body = {
        market: market,      # 예: 'KRW-BTC'
        side: 'bid',         # 매도는 'ask' 매수는 'bid'
        price: format('%.8f', krw_balance), # 매수 수량
        ord_type: 'price'   # 시장가 매수 주문
      }

      headers = generate_headers_with_keys(access_key, secret_key, body)
      response = HTTParty.post(url, headers: headers, body: body.to_json)
      order_result = handle_response(response)

      puts order_result

      # Trade 테이블에 매수 내역 저장
      strategy_info = MyStrategyInfo.find(my_strategy_info_id)
      
      Trade.create(
        coin_symbol: market,  # 'KRW-BTC'에서 'BTC' 추출
        sold: true,
        user_id: strategy_info.user_id,
        my_strategy_info_id: my_strategy_info_id,
        volume: volume,                        # 매도 수량
        remaining_volume: 0,                    # 시장가 매도는 즉시 체결되므로 남은 수량은 0
        profit: profit_rate
      )
      
      puts "매수 거래 기록 저장 완료"
  end


  def buy_percentage_of_balance(market, krw_balance_percentage, access_key, secret_key, my_strategy_info_id)
    accounts = get_accounts(access_key, secret_key)
    
    # currency = market.split('-').last # 'KRW-BTC'에서 'BTC' 추출
    krw_account = accounts.find { |a| a['currency'] == 'KRW' }
    puts "#{krw_account['balance']} 예수금 조회"
    
    buy_amount = krw_account['balance'].to_f * (krw_balance_percentage / 100.0)
    puts "총 보유량: #{krw_account['balance']}"
    puts "매수 수량: #{buy_amount} (#{krw_balance_percentage}%)"

    buy_market_order(market, buy_amount, access_key, secret_key, my_strategy_info_id, profit_rate)
    
    puts "#{krw_balance_percentage}% 매수 요청 완료"
  end

  # 현재 비트코인 수익률이 10% 이상 15%이하 이면 10% 매도
  def trade_percentage_of_balance_if_fixed_profit_rate
    @my_strategy_infos.each do |my_strategy_info|
      begin
        access_key = my_strategy_info.user.api_key.where(platform: 'upbit').first.access_key
        secret_key = my_strategy_info.user.api_key.where(platform: 'upbit').first.secret_key

        profit_rate = get_current_profit_rate(access_key, secret_key)
        # 현재 수익률이 10% 이상 15%이하 이면 10% 매도
        if profit_rate >= 10 && profit_rate <= 15
          sell_percentage_of_balance('KRW-BTC', 50, access_key, secret_key, my_strategy_info.my_strategy_info_id, profit_rate, access_key, secret_key)
        end

        # 현재 수익률이 20% 이상 25%이하 이면 20% 매도
        if profit_rate >= 20 && profit_rate <= 25
          sell_percentage_of_balance('KRW-BTC', 50, access_key, secret_key, my_strategy_info.my_strategy_info_id, profit_rate, access_key, secret_key)
        end

        # 현재 비트코인 가격 조회
        # 현재 수익률이 -10% 이상 10%이하 이면 10% 매수
        if profit_rate >= -40 && profit_rate <= -35
          accounts = get_accounts(access_key, secret_key)
          # 현재 예수금 조회
          balance = accounts.find { |a| a['currency'] == 'KRW' }['balance'].to_f
          # 현재 예수금의 50%
          krw_balance_percentage = balance * 0.5
          buy_percentage_of_balance('KRW-BTC', krw_balance_percentage, access_key, secret_key, my_strategy_info.my_strategy_info_id, profit_rate)
        end

      rescue => e
        Rails.logger.error "Error processing strategy_info #{my_strategy_info.id}: #{e.message}"
        next
      end
    end
  end

  # API 응답 처리
  def handle_response(response)
    if response.code == 200 || response.code == 201
      response.parsed_response
    else
      raise "API Error: #{response.body}"
    end
  end

  # API 키를 파라미터로 받는 헤더 생성 메소드 추가
  def generate_headers_with_keys(access_key, secret_key, payload = {})
    jwt_payload = {
      access_key: access_key,
      nonce: SecureRandom.uuid
    }

    # query_hash 계산 (파라미터가 있을 경우)
    if payload.any?
      query_string = URI.encode_www_form(payload)
      jwt_payload[:query_hash] = Digest::SHA512.hexdigest(query_string)
      jwt_payload[:query_hash_alg] = 'SHA512'
    end

    token = JWT.encode(jwt_payload, secret_key, 'HS256')
    {
      'Authorization' => "Bearer #{token}",
      'Content-Type' => 'application/json'
    }
  end

  def calculate_total_profit_rate(access_key, secret_key)
      access_key = access_key
      secret_key = secret_key
  
      puts my_strategy_info.user.id
      url = "https://api.upbit.com/v1/orders/closed"
      
      query = {
        market: "KRW-BTC",
        state: "done",
        page: 1,
        limit: 100,
        order_by: "desc"
      }

      # 쿼리 해시 생성
      query_string = URI.encode_www_form(query)
      query_hash = OpenSSL::Digest::SHA512.hexdigest(query_string)

      # JWT 토큰 생성
      payload = {
        access_key: access_key,
        nonce: SecureRandom.uuid,
        query_hash: query_hash,
        query_hash_alg: 'SHA512'
      }

      jwt_token = JWT.encode(payload, Rails.application.credentials.dig(:upbit, :secret_key), 'HS256')
      
      headers = {
        "Authorization" => "Bearer #{jwt_token}"
      }

      response = HTTParty.get(url, 
        headers: headers,
        query: query
      )

      # puts response

      return 0 unless response.code == 200

      orders = response.parsed_response
      @total_profit = 0
      @total_investment = 0
      
      orders.each do |order|
        executed_volume = order['executed_volume'].to_f
        price = order['price'].to_f
        
        # puts executed_volume
        # puts price
        
        if order['side'] == 'bid'  # 매수
          @total_investment += price * executed_volume
        else  # 매도
          # 매도 시 수익 계산
          avg_price = order['trades_avg_price'].to_f

          # puts "avg_price: #{avg_price}"
          @total_profit += (avg_price - price) * executed_volume
        end
      end

      # 현재 보유중인 BTC 조회
      nonce = SecureRandom.uuid
      payload = {
        access_key: access_key,
        nonce: nonce
      }
  
      jwt_token = JWT.encode(payload, secret_key, 'HS256')
  
      url = "https://api.upbit.com/v1/accounts"
      headers = { "Authorization" => "Bearer #{jwt_token}" }
  
      response = HTTParty.get(url, headers: headers)      
  
      if response.code == 200
        accounts = response.parsed_response
        @btc_account = accounts.select { |a| a["currency"] == "BTC" }
        @btc_balance = @btc_account.map { |a| a["balance"] }[0]
      end

      # 현재 비트코인 가격 조회
      url = "https://api.upbit.com/v1/ticker?markets=KRW-BTC"
      response = HTTParty.get(url)
      
      # puts response
  
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


      # 현재 보유 중인 BTC의 평가 손익도 포함
      if @btc_balance.to_f > 0
        current_value = @btc_balance.to_f * @bitcoin_price[:trade_price]
        cost_basis = @btc_balance.to_f * @btc_avg_buy_price.to_f

        # puts "current_value: #{current_value}"
        # puts "cost_basis: #{cost_basis}"
        @total_profit += (current_value - cost_basis)
      end
      return @total_profit
  end
end