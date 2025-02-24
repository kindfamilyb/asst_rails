class RenameAndAddProfitColumnsToTrades < ActiveRecord::Migration[7.2]
  def change
    # trades 테이블에 profit의 이름을 profit_rate로 바꾸고 profit 컬럼을 integer형식으로 생성하는 migration 파일을 만들어줘
    rename_column :trades, :profit, :profit_rate
    add_column :trades, :profit, :integer, comment: "매도당시수익금"
  end
end
