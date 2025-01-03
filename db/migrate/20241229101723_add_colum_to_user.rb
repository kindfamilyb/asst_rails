class AddColumToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :logined_yn, :string, default: 'N', null: false, comment: '로그인 여부'
  end
end
