class AddAsstNameToMyStrategyInfos < ActiveRecord::Migration[7.2]
  def change
    add_column :my_strategy_infos, :asst_name, :string, comment: '매매 자산이름'
    add_column :my_strategy_infos, :trade_delay_type, :string, comment: '매매지연 단위 주월년'
  end
end
