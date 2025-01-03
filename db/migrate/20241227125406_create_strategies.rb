class CreateStrategies < ActiveRecord::Migration[7.2]
  def change
    create_table :strategies, id: false do |t|
      t.primary_key :strategy_id
      t.string :description, null: false, default: '*', comment: "전략설명"
      t.timestamps
    end
  end
end
