class MyStrategyInfo < ApplicationRecord
    self.primary_key = 'my_strategy_info_id'
    self.table_name = 'my_strategy_infos'

    belongs_to :strategy
    belongs_to :user


    # user_id로 api_key모델을 찾아서 연관관계를 맺어줘야함
    def upbit_api_key
        upbit_api_key = ApiKey.find_by(user_id: user_id, platform: 'upbit')
        return upbit_api_key
    end

    
end
