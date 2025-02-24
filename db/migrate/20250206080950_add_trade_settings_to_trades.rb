class AddTradeSettingsToTrades < ActiveRecord::Migration[7.2]
  def change
    add_column :trades, :target_profit_rate, :integer, default: 0, comment: "목표수익률"
    add_column :trades, :trade_account_rate, :integer, default: 0, comment: "예수금매매비율"
    add_column :trades, :trade_delay_duration, :integer, default: 0, comment: "매매대기시간"
  end
end
