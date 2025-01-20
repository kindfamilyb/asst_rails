class SignalsController < ApplicationController
  def index
    response = HTTParty.get('https://jsonplaceholder.typicode.com/posts')
    posts = JSON.parse(response.body)

    # 그룹화 (예: 사용자 ID별 게시글 수)
    @chart_data = posts.group_by { |post| post['userId'] }
                       .transform_values(&:count)

    # Yahoo Finance를 사용하여 환율 데이터 조회
    begin
      yahoo_client = YahooFinance::Client.new
      symbols = ['KRW=X', 'JPY=X', '^KS11']  # USD/KRW, USD/JPY, KOSPI
      data = yahoo_client.quotes(symbols, [:symbol, :name, :last_trade_price, :change_in_percent], { raw: false })
      
      @market_data = data.map do |quote|
        {
          symbol: quote.symbol,
          name: quote.name,
          price: quote.last_trade_price,
          change_percent: quote.change_in_percent
        }
      end
    rescue => e
      Rails.logger.error("Yahoo Finance API Error: #{e.message}")
      @market_data = []
    end



    # FastAPI 서버의 /exchange_rate 엔드포인트로 요청
    # fastapi_url = ENV.fetch("FASTAPI_URL") { "http://fastapi:8000" }
    response = HTTParty.get("http://fastapi:8000/exchange_rate")

    if response.code == 200
      @exchange_data = response.parsed_response
    else
      @exchange_data = []
      flash[:alert] = "FastAPI로부터 데이터를 가져오지 못했습니다."
    end
  end
end
