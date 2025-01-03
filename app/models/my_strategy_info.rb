class MyStrategyInfo < ApplicationRecord
    self.primary_key = 'my_strategy_info_id'
    self.table_name = 'my_strategy_infos'

    belongs_to :strategy
    belongs_to :user


    # user_id로 api_key모델을 찾아서 연관관계를 맺어줘야함


    
end
