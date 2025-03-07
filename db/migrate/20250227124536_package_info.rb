class PackageInfo < ActiveRecord::Migration[7.2]
  def change
    create_table :package_infos, id: false do |t|
      t.primary_key :package_info_id
      t.string :user_id, comment: "작성자"
      t.integer :package_id, comment: "패키지아이디"
      t.integer :strategy_id, comment: "전략아이디"
      t.integer :target_profit_rate, comment: "목표수익률"
      t.integer :trade_account_rate, comment: "매매계좌비율"
      t.integer :trade_amount, comment: "매매금액"
      t.string :trade_type, comment: "매매타입"
      t.string :asst_name, comment: "자산명"
      t.string :trade_delay_duration, comment: "매매지연기간"
      t.string :trade_delay_type, comment: "매매지연타입"
      t.timestamps
    end
  end
end
