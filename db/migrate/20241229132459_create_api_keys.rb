class CreateApiKeys < ActiveRecord::Migration[7.2]
  def change
    create_table :api_keys, id: false do |t|
      t.primary_key :api_key_id
      t.integer :user_id, null: false, comment: "사용자아이디"
      t.string :access_key, null: false, comment: "엑세스키"
      t.string :secret_key, null: false, comment: "시크릿키"
      t.timestamps
    end
  end
end
