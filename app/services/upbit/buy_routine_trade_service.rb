module Upbit
    class BuyRoutineTradeService
        BASE_URL = 'https://api.upbit.com/v1'
        # initialize에 user_id 값이 없으면 빈값으로 처리
        # user_id 값이 있다면 해당 유저의 전체 전략 처리
        # user_id 값이 없다면 모든 유저의 전체 전략 처리
        def initialize(user_id: nil)
            if user_id.nil?
                @access_key = nil
                @secret_key = nil
            else
                @access_key = ApiKey.where(user_id: user_id).where(platform: 'upbit').first.access_key
                @secret_key = ApiKey.where(user_id: user_id).where(platform: 'upbit').first.secret_key
            end
        end

        # 1 모든 전략을 순회하면서 매매 주문 처리
        def trade_all_my_strategies
            all_strategies = Strategy.all

            all_strategies.each do |strategy|
                # 업비트 플렛폼 기준
                if strategy.platform == 'upbit' && strategy.strategy_type == 'routine_buy'
                    puts "1.upbit.strategy.strategy_id: #{strategy.strategy_id}"
                    my_routine_strategy_infos = MyBuyRoutineStrategyInfo.where(strategy_id: strategy.strategy_id).where(active_yn: 'Y')
                    puts "2.my_routine_strategy_infos: #{my_routine_strategy_infos.count}"

                    my_routine_strategy_infos.each do |my_routine_strategy_info|
                        # 언제 살지
                        # 얼마의 주기로 살지 week month year
                        # 얼마를 살지
                        user_id = my_routine_strategy_info.user_id
                        puts "3.user_id: #{user_id}"
                        buy_type = my_routine_strategy_info.buy_type
                        puts "4.buy_type: #{buy_type}"
                        day_of_week = my_routine_strategy_info.day_of_week
                        puts "5.day_of_week: #{day_of_week}"
                        day_of_month = my_routine_strategy_info.day_of_month
                        puts "6.day_of_month: #{day_of_month}"
                        day_of_year = my_routine_strategy_info.day_of_year
                        puts "7.day_of_year: #{day_of_year}"
                        buy_hour = my_routine_strategy_info.hour
                        puts "8.buy_hour: #{buy_hour}"
                        buy_minute = my_routine_strategy_info.minute
                        puts "9.buy_minute: #{buy_minute}"
                        buy_won_cash_account = my_routine_strategy_info.buy_won_cash_account
                        puts "10.buy_won_cash_account: #{buy_won_cash_account}"
                        access_key = my_routine_strategy_info.user.api_keys.where(platform: 'upbit').first.access_key
                        puts "11.access_key: #{access_key}"
                        secret_key = my_routine_strategy_info.user.api_keys.where(platform: 'upbit').first.secret_key
                        puts "12.secret_key: #{secret_key}"
                        my_routine_strategy_info_id = my_routine_strategy_info.id
                        puts "13.my_routine_strategy_info_id: #{my_routine_strategy_info_id}"
                        if buy_type == 'week'
                            # day_of_week 1: 월요일, 2: 화요일, 3: 수요일, 4: 목요일, 5: 금요일, 6: 토요일, 7: 일요일
                            # 매주 hour:minute 에 매매

                            # 현재 일, 월, 요일, 시간, 분 확인
                            today = Time.now
                            puts "11.today: #{today}"
                            puts "12.today.wday: #{today.wday}"
                            puts "13.today.month: #{today.month}"
                            puts "14.today.day: #{today.day}"
                            puts "15.today.hour: #{today.strftime('%H')}"
                            puts "16.today.minute: #{today.strftime('%M')}"
                            
                            if today.wday == day_of_week && today.strftime('%H') == buy_hour && today.strftime('%M').to_i.between?(buy_minute, buy_minute + 5)
                                puts "17.매매 조건 충족"
                                buy_upbit_market_order(buy_won_cash_account, access_key, secret_key, my_routine_strategy_info_id, user_id)
                            else
                                puts "18.매매 조건 불충족"
                            end
                        end
                    end
                end

                        
                        
                        
                        
                        
                        
                        
                        
                        



                       
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


        def buy_upbit_market_order(buy_won_cash_account, access_key, secret_key, my_routine_strategy_info_id, user_id)
            # puts "2-1.target_coin_name: #{target_coin_name}"
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
            Trade.create(
                coin_symbol: 'KRW-BTC',  # 'KRW-BTC'에서 'BTC' 추출
                sold: false,
                user_id: user_id,
                my_strategy_info_id: my_strategy_info_id,
                volume: buy_amount,                       # 매수 수량
                profit_rate: my_account_rate_of_return, # 매수 당시 수익률,
                trade_delay_duration: duration
            )
        end


        
    end


    

end