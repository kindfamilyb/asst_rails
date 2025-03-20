module Upbit
    class BuyRoutineTradeService
        BASE_URL = 'https://api.upbit.com/v1'
        def routine_trade_all_my_strategies
            all_my_buy_routine_strategies = MyBuyRoutineStrategyInfo.all

            all_my_buy_routine_strategies.each do |my_buy_routine_strategy|
                buy_upbit_market_order(my_buy_routine_strategy.buy_won_cash_account, my_buy_routine_strategy.upbit_api_key.access_key, my_buy_routine_strategy.upbit_api_key.secret_key, my_buy_routine_strategy.user_id)
            end
        end

        def buy_upbit_market_order(buy_amount, access_key, secret_key, user_id)
            url = "#{BASE_URL}/orders"
            body = {
                market: 'KRW-BTC',      # 예: 'KRW-BTC'
                side: 'bid',            # 매수는 'bid'
                price: buy_amount,      # 매수 금액 (KRW)
                ord_type: 'price'       # 시장가 주문
            }

            headers = generate_headers_with_keys(access_key, secret_key, body)

            response = HTTParty.post(url, headers: headers, body: body.to_json)
            order_result = handle_response(response)

            puts order_result

            # Trade 테이블에 매수 내역 저장
            begin
                Trade.create(
                    coin_symbol: 'KRW-BTC',  # 'KRW-BTC'에서 'BTC' 추출
                    sold: false,
                    user_id: user_id,
                    volume: buy_amount,                       # 매수 원화
                    trade_type: 'routine'
                )
            rescue => e
                error_message = "[#{Time.now}] 매수 거래 기록 저장 오류: #{e.message}\n"
                puts "매수 거래 기록 저장 오류: #{e.message}"
            end
        end


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

        def handle_response(response)
            if response.code == 200 || response.code == 201
                response.parsed_response
            else
                raise "API Error: #{response.body}"
            end
        end
        
    end


    

end