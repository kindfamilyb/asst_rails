class BitcoinAccountProfitSellTradingJob
  include Sidekiq::Job
  
  def perform
    # [STRATEGY1][default]
    # 현재 수익률이 10% 이상 15%이하 이면 10% 매도
    # 현재 수익률이 20% 이상 25%이하 이면 20% 매도
    # 현재 수익률이 -40% 이상 -35%이하 이면 전체 원화 예수금에 50% 매수
    UpbitApiService.trade_percentage_of_balance_if_fixed_profit_rate
  end
end 
