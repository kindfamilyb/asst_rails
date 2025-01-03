class ApiKey < ApplicationRecord
    self.primary_key = 'api_key_id'
    self.table_name = 'api_keys'

    belongs_to :user
    has_many :my_strategy_infos
    has_many :trades
end
