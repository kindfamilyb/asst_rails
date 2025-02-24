class CreateMyBuyRoutineStrategyInfos < ActiveRecord::Migration[6.1]
  def change
    create_table :my_buy_routine_strategy_infos do |t|
      t.string :user_id, comment: "유저 아이디"
      t.string :buy_type, comment: "매수주기타입week:주,month:월,year:년"
      t.string :day_of_week, comment: "요일"
      t.string :day_of_month, comment: "월 날짜"
      t.string :day_of_year, comment: "년 날짜"
      t.integer :strategy_id, comment: "전략 아이디"
      t.string :active_yn, comment: "활성화 여부"
      t.integer :hour, comment: "시간"
      t.integer :minute, comment: "분"
      t.integer :buy_won_cash_account, comment: "매수 원화 계좌량"

      t.timestamps
    end
  end
end 