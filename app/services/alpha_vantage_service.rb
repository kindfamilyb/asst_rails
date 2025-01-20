require 'net/http'
require 'json'
require 'yahoo-finance'

class AlphaVantageService
  BASE_URL = "https://www.alphavantage.co/query"
  API_KEY = Rails.application.credentials.alpha_vantage_api_key

  def self.fetch_exchange_rate(base_currency:, target_currency:, range_week: 1)
    function = "FX_DAILY"
    uri = URI("#{BASE_URL}?function=#{function}&from_symbol=#{base_currency}&to_symbol=#{target_currency}&apikey=#{API_KEY}")

    response = Net::HTTP.get(uri)
    data = JSON.parse(response)

    # "Time Series FX (Daily)" 키에서 날짜별 환율 데이터 추출
    daily_data = data["Time Series FX (Daily)"]
    return [] unless daily_data

    # 오늘 날짜 기준으로 range_week 주 전까지의 데이터만 필터링
    end_date = Date.today
    start_date = end_date - (range_week * 7)

    # 날짜별 환율 데이터를 파싱하여 반환
    daily_data.map do |date, rates|
      parsed_date = Date.parse(date)
      next unless parsed_date.between?(start_date, end_date)

      {
        date: parsed_date,
        open: rates["1. open"].to_f,
        high: rates["2. high"].to_f,
        low: rates["3. low"].to_f,
        close: rates["4. close"].to_f
      }
    end.compact.sort_by { |item| item[:date] }
  end
end
