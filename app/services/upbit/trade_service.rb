module Upbit
    class TradeService
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
                if strategy.platform == 'upbit' && strategy.strategy_type == 'custom'
                    puts "1.upbit.strategy.strategy_id: #{strategy.strategy_id}"
                    my_strategy_infos = MyStrategyInfo.where(strategy_id: strategy.strategy_id).where(active_yn: 'Y')
                    puts "2.my_strategy_infos: #{my_strategy_infos.count}"

                    my_strategy_infos.each do |my_strategy_info|
                        user_id = my_strategy_info.user_id
                        puts "3.my_strategy_info: #{my_strategy_info.my_strategy_info_id}"
                        # 내 계좌 수익율 계산
                        my_account_rate_of_return = Upbit::AccountInfosService.new(user_id: my_strategy_info.user_id).get_btc_current_profit_rate
                        puts "4.my_account_rate_of_return: #{my_account_rate_of_return}"
                        # 타겟 수익률
                        target_trade_rate_number = my_strategy_info.target_profit_rate.to_f
                        puts "5.target_trade_rate_number: #{target_trade_rate_number}"
                        # 타겟 코인 이름
                        # target_coin_symbol = my_strategy_info.asst_name
                        # 내 계좌 잔고 조회
                        my_accounts = Upbit::AccountInfosService.new(user_id: my_strategy_info.user_id).get_accounts
                        puts "6.my_accounts: #{my_accounts}"
                        # 원화 계좌 잔고 조회
                        krw_account_balance = my_accounts.find { |a| a['currency'] == 'KRW' }['balance'].to_f
                        puts "7.krw_account_balance: #{krw_account_balance}"
                        # 매매지연 단위
                        trade_delay_type = my_strategy_info.trade_delay_type
                        puts "8.trade_delay_type: #{trade_delay_type}"
                        # 매매지연 기간
                        trade_delay_duration = my_strategy_info.trade_delay_duration
                        puts "9.trade_delay_duration: #{trade_delay_duration}"
                        # 총 보유량
                        account_asst_balance = my_accounts.find { |a| a['currency'] == my_strategy_info.asst_name }
                        target_coin_balance = account_asst_balance['balance'].to_f
                        puts "11.target_coin_balance: #{target_coin_balance}"

                        access_key = my_strategy_info.user.api_key.where(platform: 'upbit').first.access_key
                        secret_key = my_strategy_info.user.api_key.where(platform: 'upbit').first.secret_key
                        
                        

                        if my_strategy_info.trade_type == 'sell' && my_strategy_info.trade_type.present?
                            # 매도라면
                            puts "13.my_strategy_info: #{my_strategy_info.my_strategy_info_id}"
                            puts "14.my_account_rate_of_return: #{my_account_rate_of_return}"
                            

                            puts "15.target_trade_rate_number: #{target_trade_rate_number}"
                            puts "14-15.target_trade_rate_number: #{my_account_rate_of_return >= target_trade_rate_number && my_account_rate_of_return <= target_trade_rate_number + 3}"
                            puts "14-15.target_trade_rate_number: #{my_account_rate_of_return <= target_trade_rate_number}"
                            puts "14-15.target_trade_rate_number: #{my_account_rate_of_return >= -target_trade_rate_number}"

                            # 매도 수량
                            if my_strategy_info.trade_account_rate.present?
                                trade_account_rate_number = my_strategy_info.trade_account_rate.to_f
                                sell_amount = target_coin_balance * (trade_account_rate_number / 100.0)
                                puts "12-1.sell_amount: #{sell_amount}"
                                puts "12-2.trade_account_rate_number: #{trade_account_rate_number}"
                            else
                                sell_amount = target_coin_balance * (50 / 100.0)
                                puts "12-1-1.sell_amount: #{sell_amount}"
                                # puts "12-2-2.trade_account_rate_number: #{trade_account_rate_number}"
                            end

                            # if my_account_rate_of_return <= target_trade_rate_number # 테스트용 조건
                            if my_account_rate_of_return >= target_trade_rate_number && my_account_rate_of_return <= target_trade_rate_number + 3
                                # 매도
                                puts "15.매도 조건 충족"
                                # puts "16.target_coin_name: #{target_coin_name}"
                                puts "17.target_trade_rate_number: #{target_trade_rate_number}"
                                puts "18.sell_amount: #{sell_amount}"
                                puts "19.access_key: #{access_key}"
                                puts "20.secret_key: #{secret_key}"
                                puts "21.my_strategy_info.my_strategy_info_id: #{my_strategy_info.my_strategy_info_id}"
                                puts "22.trade_delay_type: #{trade_delay_type}"
                                puts "23.trade_delay_duration: #{trade_delay_duration}"

                                puts "24.my_account_rate_of_return: #{my_account_rate_of_return}"

                                # profit = Upbit::AccountInfosService.new(user_id: my_strategy_info.user_id).calculate_total_profit_rate * (trade_account_rate_number / 100.0)
                                # puts "24.1.profit: #{Upbit::AccountInfosService.new(user_id: my_strategy_info.user_id).calculate_total_profit_rate}"
                                
                                
                                total_profit_cash = Upbit::AccountInfosService.new(user_id: user_id).calculate_total_profit_cash

                                
                                puts "25.total_profit_cash: #{total_profit_cash}"

                                real_profit_cash = total_profit_cash * (trade_account_rate_number / 100.0)

                                puts "26.real_profit: #{real_profit_cash.round(0)}"



                                today = Date.today
                                # 매매지연이 trade_delay_type이 week, month, year에 따라 분기처리
                                if trade_delay_type == 'week'
                                    duration = today.beginning_of_week..today.end_of_week
                                elsif trade_delay_type == 'month'
                                    duration = today.beginning_of_month..today.end_of_month
                                elsif trade_delay_type == 'year'
                                    duration = today.beginning_of_year..today.end_of_year
                                end

                                puts "25.duration: #{duration}"

                                if Trade.where(my_strategy_info_id: my_strategy_info.my_strategy_info_id, sold: true, created_at: duration).exists?
                                    puts "이번 #{trade_delay_type} 에 같은 전략으로 매도한 거래내역이 있습니다."
                                    return
                                end

                                begin
                                    # sell_upbit_percentage_of_balance(target_coin_name, target_trade_rate_number, sell_amount, access_key, secret_key, my_strategy_info.my_strategy_info_id, trade_delay_type, trade_delay_duration)
                                    sell_upbit_market_order(target_trade_rate_number, sell_amount, access_key, secret_key, my_strategy_info.my_strategy_info_id, my_account_rate_of_return, real_profit_cash, user_id)
                                    puts "매도 주문 완료"
                                rescue => e
                                    puts "매도 주문 오류: #{e.message}"
                                end
                            end
                        end

                        puts "매도조건확인전"
                        if my_strategy_info.trade_type == 'buy' && my_strategy_info.trade_type.present?

                            puts "50.my_account_rate_of_return_true #{my_account_rate_of_return <= target_trade_rate_number}"
                            puts "51.my_account_rate_of_return_true #{my_account_rate_of_return <= target_trade_rate_number && my_account_rate_of_return >= target_trade_rate_number - 3}"

                            if my_account_rate_of_return <= target_trade_rate_number && my_account_rate_of_return >= target_trade_rate_number - 3
                                # 매수
                                # 매수 수량

                                # 매도 수량
                                # 매도 비율 계산
                                trade_account_rate_number = my_strategy_info.trade_account_rate.to_f
                                # 총 보유량 계산
                                krw_balance = my_accounts.find { |a| a['currency'] == 'KRW' }['balance'].to_f
                                puts "3-27.total_balance: #{krw_balance}"

                                # 매수 수량 계산
                                buy_amount = (krw_balance * (trade_account_rate_number / 100.0)).round(0)
                                puts "3-28.buy_amount: #{buy_amount}"
                                
                                # 총 수익금 계산
                                # total_profit_cash = Upbit::AccountInfosService.new(user_id: user_id).calculate_total_profit_cash
                                # puts "25.total_profit_cash: #{total_profit_cash}"

                                # real_profit_cash = total_profit_cash * (trade_account_rate_number / 100.0)
                                # puts "26.real_profit: #{real_profit_cash.round(0)}"



                                today = Date.today
                                # 매매지연이 trade_delay_type이 week, month, year에 따라 분기처리
                                if trade_delay_type == 'week'
                                    duration = today.beginning_of_week..today.end_of_week
                                elsif trade_delay_type == 'month'
                                    duration = today.beginning_of_month..today.end_of_month
                                elsif trade_delay_type == 'year'
                                    duration = today.beginning_of_year..today.end_of_year
                                end

                                puts "3-25.duration: #{duration}"

                                if Trade.where(my_strategy_info_id: my_strategy_info.my_strategy_info_id, sold: false, created_at: duration).exists?
                                    puts "이번 #{trade_delay_type} 에 같은 전략으로 매수한 거래내역이 있습니다."
                                    return
                                end
                                
                                begin
                                    # sell_upbit_percentage_of_balance(target_coin_name, target_trade_rate_number, sell_amount, access_key, secret_key, my_strategy_info.my_strategy_info_id, trade_delay_type, trade_delay_duration)
                                    buy_upbit_market_order(target_trade_rate_number, buy_amount, access_key, secret_key, my_strategy_info.my_strategy_info_id, my_account_rate_of_return, real_profit_cash, user_id)
                                    puts "매수 주문 완료"
                                rescue => e
                                    puts "매수 주문 오류: #{e.message}"
                                end
                            end
                            # 매수
                        end
               
                    end
                end

                if strategy.platform == 'hanguk'
                    # 한국투자증권 플렛폼 기준
                    # 한국투자증권 플렛폼 기준
                end
            end
        end

        # def sell_upbit_percentage_of_balance(market, target_trade_rate_number, sell_amount, access_key, secret_key, my_strategy_info_id, trade_delay_type, trade_delay_duration)
        #     # 퍼센트 값 검증
        #     today = Date.today
        #     # 매매지연이 trade_delay_type이 week, month, year에 따라 분기처리
        #     if trade_delay_type == 'week'
        #         duration = today.beginning_of_week..today.end_of_week
        #     elsif trade_delay_type == 'month'
        #         duration = today.beginning_of_month..today.end_of_month
        #     elsif trade_delay_type == 'year'
        #         duration = today.beginning_of_year..today.end_of_year
        #     end

        #     # if Trade.where(my_strategy_info_id: my_strategy_info_id, sold: true, created_at: duration).exists?
        #     #   puts "이번 #{trade_delay_type} 에 같은 전략으로 매도한 거래내역이 있습니다."
        #     #   return
        #     # end

        #     # sell_upbit_market_order(market, target_trade_rate_number, sell_amount, my_strategy_info_id, access_key, secret_key)
            
        #     puts "#{target_trade_rate_number}% 매도 요청 완료"
        # end
        
        # 매도
        # sell_upbit_market_order(target_coin_name, target_trade_rate_number, sell_amount, access_key, secret_key, my_strategy_info.my_strategy_info_id, my_account_rate_of_return, real_profit_cash)
        
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

        def sell_upbit_market_order(target_trade_rate_number, sell_amount, access_key, secret_key, my_strategy_info_id, my_account_rate_of_return, real_profit_cash, user_id)
            # puts "2-1.target_coin_name: #{target_coin_name}"
            puts "3-2.target_trade_rate_number: #{target_trade_rate_number}"
            puts "3-3.sell_amount: #{sell_amount}"
            puts "3-4.access_key: #{access_key}"
            puts "3-5.secret_key: #{secret_key}"
            puts "3-6.my_strategy_info_id: #{my_strategy_info_id}"
            puts "3-7.my_account_rate_of_return: #{my_account_rate_of_return}"
            puts "3-8.real_profit_cash: #{real_profit_cash}"
            puts "3-9.user_id: #{user_id}"
            url = "#{BASE_URL}/orders"
            body = {
                market: 'KRW-BTC',      # 예: 'KRW-BTC'
                side: 'ask',         # 매도는 'ask'
                volume: format('%.8f', sell_amount), # 매도 수량
                ord_type: 'market'   # 시장가 주문
            }

            headers = generate_headers_with_keys(access_key, secret_key, body)

            response = HTTParty.post(url, headers: headers, body: body.to_json)
            order_result = handle_response(response)

            puts order_result

            # Trade 테이블에 매도 내역 저장
            # strategy_info = MyStrategyInfo.find(my_strategy_info_id)
            # calculate_total_profit_rate의 50% 수익금을 계산 
            
            
            Trade.create(
                coin_symbol: 'KRW-BTC',  # 'KRW-BTC'에서 'BTC' 추출
                sold: true,
                user_id: user_id,
                my_strategy_info_id: my_strategy_info_id,
                volume: sell_amount,                        # 매도 수량
                profit_rate: my_account_rate_of_return, # 매도 당시 수익률
                profit: real_profit_cash.round(0), # 매도시 실 수익금
                target_trade_rate_number: target_trade_rate_number
            )
            
            puts "매도 거래 기록 저장 완료"
        end


        def buy_upbit_market_order(target_trade_rate_number, buy_amount, access_key, secret_key, my_strategy_info_id, my_account_rate_of_return, real_profit_cash, user_id)
            # puts "2-1.target_coin_name: #{target_coin_name}"
            puts "2-2.target_trade_rate_number: #{target_trade_rate_number}"
            puts "2-3.buy_amount: #{buy_amount}"
            puts "2-4.access_key: #{access_key}"
            puts "2-5.secret_key: #{secret_key}"    
        

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
                profit_rate: my_account_rate_of_return, # 매수 당시 수익률
            )
        end


        # 2 특정 ID의 전략 기준으로 매매 주문 처리
        def trade_specific_user_id_strategies(user_id)
            all_my_strategy_infos = MyStrategyInfo.where(user_id: user_id)

            all_my_strategy_infos.each do |info|
                # 내 계좌 수익율 계산
                # 매수 매도 기준확인
                    # 매수 전략이라면
                        # 파라미터 ( market, krw_balance, access_key, secret_key, my_strategy_info_id, profit_rate)                    
                        # 매수

                    # 매도 전략이라면
                        # 파라미터 ( market, percentage, volume, my_strategy_info_id, profit_rate)                    
                        # 매도
            end
        end
    end


    

end