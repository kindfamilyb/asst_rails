class AddColumnsToApiKeys < ActiveRecord::Migration[7.2]
  def change
    add_column :api_keys, :api_key, :string, comment: "api_key"
    add_column :api_keys, :api_secret, :string, comment: "api_secret"
    add_column :api_keys, :account_number, :string, comment: "계좌번호"
    add_column :api_keys, :account_code, :string, comment: "계좌코드"
  end
end
