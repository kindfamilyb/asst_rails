class AddColumToMyStrategyInfo < ActiveRecord::Migration[7.2]
  def change
    add_column :my_strategy_infos, :package_id, :integer, comment: "패키지아이디"
  end
end
