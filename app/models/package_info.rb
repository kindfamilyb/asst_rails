class PackageInfo < ApplicationRecord
    self.table_name = "package_infos"
    self.primary_key = "package_info_id"

    belongs_to :package, foreign_key: "package_id", class_name: "Package"
end
