class AddColumTradeTypeToTrades < ActiveRecord::Migration[7.2]
  def change
    add_column :trades, :trade_type, :string, comment: '정기매수(routine), 조건매수(strategy)'
  end
end
