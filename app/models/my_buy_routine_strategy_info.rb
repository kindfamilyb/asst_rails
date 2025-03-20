class MyBuyRoutineStrategyInfo < ApplicationRecord
  belongs_to :user
  belongs_to :strategy

  # 추가적인 유효성 검사나 메서드를 여기에 정의할 수 있습니다.

  def upbit_api_key
    upbit_api_key = ApiKey.find_by(user_id: self.user_id, platform: 'upbit')
    return upbit_api_key
  end
end 