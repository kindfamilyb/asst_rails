class AddPlatformToStrategies < ActiveRecord::Migration[7.2]
  def change
    add_column :strategies, :platform, :string
    add_column :strategies, :strategy_type, :string
  end
end
