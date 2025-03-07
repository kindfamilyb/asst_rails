class AddColumToPackage < ActiveRecord::Migration[7.2]
  def change
    add_column :packages, :download_count, :integer, default: 0, comment: "다운로드 수"
  end
end
