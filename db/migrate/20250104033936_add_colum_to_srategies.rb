class AddColumToSrategies < ActiveRecord::Migration[7.2]
  def change
    add_column :strategies, :title, :string, comment: '전략명'
  end
end