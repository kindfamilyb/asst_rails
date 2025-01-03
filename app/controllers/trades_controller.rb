# app/controllers/trades_controller.rb
class TradesController < ApplicationController
    def index
      @trades = Trade.all
      @current_price = Redis.current.get('btc_current_price')
    end
  
    # 매수 주문(Trade 생성) 예시
    def create
      buy_price = Redis.current.get('btc_current_price').to_f
      Trade.create(buy_price: buy_price, coin_symbol: 'BTC')
      redirect_to trades_path, notice: '새로운 Trade가 생성되었습니다.'
    end
  end
  