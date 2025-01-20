class AddColumProfitToTrades < ActiveRecord::Migration[7.2]
  def change
    add_column :trades, :profit, :float, comment: '수익'
  end
end
