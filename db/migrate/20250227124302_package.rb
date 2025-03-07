class Package < ActiveRecord::Migration[7.2]
  def change
    create_table :packages, id: false do |t|
      t.primary_key :package_id
      t.string :title, comment: "패키지명"
      t.string :description, comment: "패키지설명"
      t.string :package_type, comment: "패키지타입"
      t.string :platform, comment: "플랫폼"
      t.timestamps
    end
  end
end
