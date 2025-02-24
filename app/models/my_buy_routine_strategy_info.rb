class MyBuyRoutineStrategyInfo < ApplicationRecord
  belongs_to :user
  belongs_to :strategy

  # 추가적인 유효성 검사나 메서드를 여기에 정의할 수 있습니다.
end 