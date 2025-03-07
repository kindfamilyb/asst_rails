class Package < ApplicationRecord
    self.table_name = "packages"
    self.primary_key = "package_id"

    has_many :package_infos, foreign_key: "package_id", class_name: "PackageInfo"
end
