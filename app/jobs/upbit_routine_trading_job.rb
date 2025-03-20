class UpbitRoutineTradingJob
  include Sidekiq::Job
  
  def perform
    service = Upbit::BuyRoutineTradeService.new
    service.routine_trade_all_my_strategies
  end
end 
