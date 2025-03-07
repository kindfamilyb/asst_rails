class PackageDownload < ActiveRecord::Migration[7.2]
  def change
    create_table :package_downloads, id: false do |t|
      t.primary_key :package_download_id
      t.integer :package_id, comment: "패키지아이디"
      t.integer :user_id, comment: "사용자아이디"
      t.timestamps
    end
  end
end
