class Market < ActiveRecord::Migration[7.2]
  def change
    create_table :markets, id: false do |t|
      t.primary_key :market_id
      t.string :market_name, comment: "마켓명"
      t.string :market_description, comment: "마켓설명"
      t.string :package_id, comment: "패키지아이디"
      t.string :platform, comment: "플랫폼"
      t.string :asst_name, comment: "자산명"
      t.string :market_type, comment: "마켓타입"
      t.timestamps
    end
  end
end
