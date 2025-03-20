class CreateBuyRoutineSettings < ActiveRecord::Migration[7.2]
  def change
    create_table :buy_routine_settings do |t|
      t.integer :user_id, comment: '유저아이디'
      t.integer :buy_amount, comment: '매수금액'
      t.string :every_day_yn, comment: '매일매수여부'
      t.string :week, comment: '매주요일매수'
      t.string :month, comment: '매월매수일'
      t.string :active_yn, comment: '활성화여부'
      t.string :exposure_yn, comment: '노출여부'

      t.timestamps
    end
  end
end
