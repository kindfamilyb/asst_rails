class AddColumnsToMyStrategyInfos < ActiveRecord::Migration[7.2]
  def change
    add_column :my_strategy_infos, :target_profit_rate, :integer, comment: '목표 매매수익율'
    add_column :my_strategy_infos, :trade_account_rate, :integer, comment: '매매 계좌 비율'
    add_column :my_strategy_infos, :trade_delay_duration, :integer, comment: '매매 지연 시간'
  end
end
