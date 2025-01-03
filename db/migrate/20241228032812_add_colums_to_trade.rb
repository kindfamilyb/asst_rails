class AddColumsToTrade < ActiveRecord::Migration[7.2]
  def change
    add_column :trades, :user_id, :integer, comment: '유저ID'
    add_column :trades, :my_strategy_info_id, :integer, comment: '내전략ID'
  end
end
