class SignalsController < ApplicationController
  def index
    # FastAPI 서버의 /exchange_rate 엔드포인트로 요청
    # fastapi_url = ENV.fetch("FASTAPI_URL") { "http://fastapi:8000" }
    response = HTTParty.get("http://fastapi:8000/exchange_rate")

    @dollar_index_data = response['dollar_index_close']['DX-Y.NYB']
    @usd_krw_data = response['krw_usd_close']['USDKRW=X']
    @dollar_index_close_norm = response['dollar_index_close_norm']['DX-Y.NYB']
    @krw_usd_close_r_norm = response['krw_usd_close_r_norm']['USDKRW=X']

    @sales_data = {
      "2025-01-01" => 120,
      "2025-01-02" => 150,
      "2025-01-03" => 170,
      "2025-01-04" => 100
    }

    # 샘플 데이터: 제품별 판매 수량
    @product_data = {
      "Product A" => 30,
      "Product B" => 50,
      "Product C" => 40
    }
    
  end
end
