class AddColumToMystrategyInfo < ActiveRecord::Migration[7.2]
  def change
    add_column :my_strategy_infos, :sell_target_type, :string, comment: '매도 타입(account:예수금, volume:코인보유량, auto:자동)'
  end
end
