class AddMyBuyRoutineStrategyInfoIdToTrades < ActiveRecord::Migration[7.2]
  def change
    add_column :trades, :my_buy_routine_strategy_info_id, :integer, comment: "매수 루틴 전략 정보 ID"
  end
end
