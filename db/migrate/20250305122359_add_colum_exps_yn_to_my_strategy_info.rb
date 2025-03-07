class AddColumExpsYnToMyStrategyInfo < ActiveRecord::Migration[7.2]
  def change
    add_column :my_strategy_infos, :exposure_yn, :string, default: 'N', comment: '노출여부'
  end
end
