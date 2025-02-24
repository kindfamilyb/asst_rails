module upbit
    class MyStrategyInfosLoopsService

        def initialize
            @my_strategy_infos = MyStrategyInfo.where(strategy_id: 1, active_yn: 'Y')
        end
        
        def trade_percentage_of_balance_if_fixed_profit_rate
            @my_strategy_infos.each do |my_strategy_info|
              begin
                access_key = my_strategy_info.user.api_key.where(platform: 'upbit').first.access_key
                secret_key = my_strategy_info.user.api_key.where(platform: 'upbit').first.secret_key
        
                profit_rate = Upbit::AccountInfosService.new(user_id: my_strategy_info.user_id).get_btc_current_profit_rate
                
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

          

    end
end