class Trade < ApplicationRecord
  self.table_name = 'trades'     # 테이블명 지정
  self.primary_key = 'trade_id'  # 커스텀 primary key 지정
  # 매도 여부에 따라 비즈니스 로직을 추가할 수도 있습니다.
  
  # 수익률 계산 메소드 예시
  def profit_rate(current_price)
    return 0 if buy_price.zero?
    ((current_price - buy_price) / buy_price.to_f) * 100.0
  end
end
