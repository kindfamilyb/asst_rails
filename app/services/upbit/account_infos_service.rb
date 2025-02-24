module Upbit
    class AccountInfosService
        BASE_URL = 'https://api.upbit.com/v1'
        # 호출방식
        # Upbit::config::AccountInfosService.new(user_id: 1).get_btc_current_profit_rate
        def initialize(user_id:)
            @access_key = ApiKey.where(user_id: user_id).where(platform: 'upbit').first.access_key
            @secret_key = ApiKey.where(user_id: user_id).where(platform: 'upbit').first.secret_key
            price_service = Upbit::PriceInfosService.new
            @btc_current_price = price_service.bitcoin_price
        end

        # 계좌 정보 조회
        def get_accounts
          url = "#{BASE_URL}/accounts"
          headers = generate_headers_with_keys(@access_key, @secret_key)
          response = HTTParty.get(url, headers: headers)
          handle_response(response)
        end

        # 헤더 생성
        def generate_headers_with_keys(access_key, secret_key, payload = {})
          jwt_payload = {
            access_key: @access_key,
            nonce: SecureRandom.uuid
          }
      
          # query_hash 계산 (파라미터가 있을 경우)
          if payload.any?
            query_string = URI.encode_www_form(payload)
            jwt_payload[:query_hash] = Digest::SHA512.hexdigest(query_string)
            jwt_payload[:query_hash_alg] = 'SHA512'
          end
      
          token = JWT.encode(jwt_payload, @secret_key, 'HS256')
          {
            'Authorization' => "Bearer #{token}",
            'Content-Type' => 'application/json'
          }
        end

        # API 응답 hash, array 형식으로 반환
        def handle_response(response)
          if response.code == 200 || response.code == 201
            response.parsed_response
          else
            raise "API Error: #{response.body}"
          end
        end

        # 현재 계좌 수익율
        def get_btc_current_profit_rate
          # Upbit::PriceInfosService.bitcoin_price
          # 현재 비트코인 가격 업데이트
          # bitcoin_price # 현재 비트코인 가격 업데이트
      
          accounts = get_accounts
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

        # 현재 평가금액
        def calculate_total_profit_rate
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
            access_key: @access_key,
            nonce: SecureRandom.uuid,
            query_hash: query_hash,
            query_hash_alg: 'SHA512'
          }
    
          jwt_token = JWT.encode(payload, @secret_key, 'HS256')
          
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
            access_key: @access_key,
            nonce: nonce
          }
      
          jwt_token = JWT.encode(payload, @secret_key, 'HS256')
      
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

        # 현재 수익금(원화)
        def calculate_total_profit_cash
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
            access_key: @access_key,
            nonce: SecureRandom.uuid,
            query_hash: query_hash,
            query_hash_alg: 'SHA512'
          }
      
          jwt_token = JWT.encode(payload, @secret_key, 'HS256')
          
          headers = {
            "Authorization" => "Bearer #{jwt_token}"
          }
      
          response = HTTParty.get(url, 
            headers: headers,
            query: query
          )
      
          return 0 unless response.code == 200
      
          orders = response.parsed_response
          total_profit_cash = 0
          total_investment_cash = 0
          
          orders.each do |order|
            executed_volume = order['executed_volume'].to_f
            price = order['price'].to_f
            
            if order['side'] == 'bid'  # 매수
              total_investment_cash += price * executed_volume
            else  # 매도
              # 매도 시 수익 계산
              avg_price = order['trades_avg_price'].to_f
              total_profit_cash += (avg_price - price) * executed_volume
            end
          end

          accounts = get_accounts
          krw_account = accounts.select { |a| a["currency"] == "KRW" }
          krw_balance = krw_account.map { |a| a["balance"] }[0].to_i
      
          btc_account = accounts.select { |a| a["currency"] == "BTC" }
          btc_balance = btc_account.map { |a| a["balance"] }[0]
          btc_avg_buy_price = btc_account.map { |a| a["avg_buy_price"] }[0]
      
          # 현재 보유 중인 BTC의 평가 손익도 포함
          if btc_balance.to_f > 0
            current_value = btc_balance.to_f * Upbit::PriceInfosService.new.bitcoin_price
            cost_basis = btc_balance.to_f * btc_avg_buy_price.to_f
            total_profit_cash += (current_value - cost_basis)
          end

          puts "response: #{response}"
          puts "total_investment: #{total_investment_cash}"
          puts "btc_balance: #{btc_balance}"
          puts "btc_avg_buy_price: #{btc_avg_buy_price}"
          puts "bitcoin_price: #{Upbit::PriceInfosService.new.bitcoin_price}"
          total_profit_cash   
          # return 0 if @total_investment == 0
          # ((@total_profit / @total_investment) * 100).round(2)
          # @total_profit.round(0)
        end
     end
end