class CreateMyStrategyInfos < ActiveRecord::Migration[7.2]
  def change
    create_table :my_strategy_infos, id: false do |t|
      t.primary_key :my_strategy_info_id
      t.integer :user_id, null: false, comment: "사용자아이디"
      t.integer :signal_number, comment: "신호숫자"
      t.integer :strategy_id, null: false, comment: "전략아이디"
      t.string :active_yn, null: false, default: 'Y', comment: "활성여부"
      t.string :delete_yn, null: false, default: 'N', comment: "삭제여부"
      t.timestamps
    end
  end
end
