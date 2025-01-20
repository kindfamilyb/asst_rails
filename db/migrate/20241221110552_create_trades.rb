class CreateTrades < ActiveRecord::Migration[7.0]
  def change    
    create_table :trades, id: false do |t|
      t.primary_key :trade_id

      t.string :coin_symbol, null: false, default: 'BTC'
      t.decimal :buy_price,  null: false, precision: 15, scale: 5
      t.decimal :sell_price, precision: 15, scale: 5
      t.boolean :sold, default: false

      t.timestamps
    end
  end
end