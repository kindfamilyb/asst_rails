class Strategy < ApplicationRecord
  self.primary_key = 'strategy_id'
  self.table_name = 'strategies'

  has_many :my_strategy_infos
  has_many :my_buy_routine_strategy_infos

  # stragegy 삭제시 삭제된 strategy의 my_strategy_infos 비활성화
  after_destroy :deactivate_my_strategy_infos
  after_destroy :deactivate_my_buy_routine_strategy_infos
  def deactivate_my_strategy_infos
    my_strategy_infos.update_all(active_yn: 'N')
  end

  # stragegy 삭제시 삭제된 strategy의 my_buy_routine_strategy_infos 비활성화
  def deactivate_my_buy_routine_strategy_infos
    my_buy_routine_strategy_infos.update_all(active_yn: 'N')
  end
end
