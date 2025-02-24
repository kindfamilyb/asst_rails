class AddTradeTypeToMyStrategyInfos < ActiveRecord::Migration[7.2]
  def change
    add_column :my_strategy_infos, :trade_type, :string, comment: '매매 타입'
  end
end
