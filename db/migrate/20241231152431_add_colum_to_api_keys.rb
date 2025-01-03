class AddColumToApiKeys < ActiveRecord::Migration[7.2]
  def change
    add_column :api_keys, :platform, :string, comment: 'api_key가 사용되는 플랫폼'
  end
end
