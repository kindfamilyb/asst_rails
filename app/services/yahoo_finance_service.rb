# app/services/yahoo_finance_service.rb

require 'yfinance'

class YahooFinanceService
  def fetch_exchange_data(base_currency:, target_currency:, start_date:, end_date:)
    # Yahoo Finance에서 USD/KRW 데이터 불러오기 위해 ticker 심볼 지정 (예: USDKRW => "KRW=X")
    # 심볼은 실제 yahoo finance의 고유 표시를 확인해야 합니다.
    symbol = symbol_for(base_currency: base_currency, target_currency: target_currency)

    # yahoo-finance gem 기능 사용
    data = Yahoo::Finance.historical(symbol, start_date, end_date)

    # data는 해시 배열 형태로 반환됨(날짜, 시가, 종가 등)
    # [{ date: "2023-12-01", open: 1200.0, high: 1210.0, low: 1190.0, close: 1205.0, volume: 0 }, ... ]
    # 원하는 형태로 파싱 후 반환
    data.map do |d|
      {
        date:  Date.parse(d[:date]),
        open:  d[:open],
        high:  d[:high],
        low:   d[:low],
        close: d[:close],
        volume: d[:volume],
      }
    end
  end

  private

  def symbol_for(base_currency:, target_currency:)
    # Yahoo Finance 심볼 규칙에 따라 심볼 변환 로직 작성
    # 예: USD/KRW => "KRW=X", USD/EUR => "EUR=X"
    # 실제 규칙은 Yahoo Finance에 따라 다를 수 있음
    return "#{target_currency}=X" if base_currency == "USD" 
    # 필요 시 로직 확장
  end
end
