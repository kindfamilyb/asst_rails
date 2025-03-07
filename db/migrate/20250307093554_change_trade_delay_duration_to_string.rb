class ChangeTradeDelayDurationToString < ActiveRecord::Migration[7.2]
  def change
    change_column :trades, :trade_delay_duration, :string
  end
end
