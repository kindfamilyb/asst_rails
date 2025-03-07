class PackageDownload < ApplicationRecord
    self.table_name = "package_downloads"
    self.primary_key = "package_download_id"

    belongs_to :package, foreign_key: "package_id", class_name: "Package"
end
