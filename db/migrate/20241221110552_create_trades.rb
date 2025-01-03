class CreateTrades < ActiveRecord::Migration[7.0]
  def change
    # 기본 id 컬럼 대신, 직접 primary key를 지정하려면 id: false 로 해야함
    create_table :trades, id: false do |t|
      # primary_key :trade_id => trade_id라는 이름으로 PK 생성
      t.primary_key :trade_id

      t.string :coin_symbol, null: false, default: 'BTC'
      t.decimal :buy_price,  null: false, precision: 15, scale: 5
      t.decimal :sell_price, precision: 15, scale: 5
      t.boolean :sold, default: false

      t.timestamps
    end
  end
end