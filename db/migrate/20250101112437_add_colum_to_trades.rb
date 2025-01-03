class AddColumToTrades < ActiveRecord::Migration[7.2]
  def change
    add_column :trades, :volume, :float, comment: '매도수량'
    add_column :trades, :remaining_volume, :float, comment: '남은수량'
    remove_column :trades, :buy_price
    remove_column :trades, :sell_price
  end
end
