class ExchangeRate < ApplicationRecord
    self.table_name = "exchange_rates"
    primary_key :id
end
