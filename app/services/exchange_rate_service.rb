# app/services/exchange_rate_service.rb
require 'net/http'
require 'json'

class ExchangeRateService
  YAHOO_FINANCE_API_URL = "https://query1.finance.yahoo.com/v8/finance/chart".freeze

  def self.fetch_exchange_rate(from_currency, to_currency, days = 1)
    new(from_currency, to_currency, days).fetch_exchange_rate
  end

  def initialize(from_currency, to_currency, days)
    @from_currency = from_currency
    @to_currency = to_currency
    @days = days
  end

  def fetch_exchange_rate
    response = make_request
    parse_response(response)
  rescue StandardError => e
    Rails.logger.error("ExchangeRateService Error: #{e.message}")
    nil
  end

  private

  def make_request
    range = calculate_range(@days)
    uri = URI("#{YAHOO_FINANCE_API_URL}/#{@from_currency}#{@to_currency}=X")
    uri.query = URI.encode_www_form(interval: '1d', range: range)
  
    sleep(1) # 요청 간 대기 시간 추가

    Rails.logger.info("Request URL: #{uri}") # 요청 URL 로그
  
    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new(uri)
      response = http.request(request)
      Rails.logger.info("Response Code: #{response.code}") # 상태 코드 로그
      Rails.logger.info("Response Body: #{response.body}") # 응답 본문 로그
      response
    end
  end

  def calculate_range(days)
    "#{days}d"
  end
  
  def parse_response(response)
    return nil unless response.is_a?(Net::HTTPSuccess)
  
    data = JSON.parse(response.body)
    Rails.logger.info("Parsed Data: #{data}") # 파싱 데이터 로그
  
    close_prices = data.dig('chart', 'result', 0, 'indicators', 'quote', 0, 'close')
    close_prices
  rescue JSON::ParserError => e
    Rails.logger.error("JSON Parsing Error: #{e.message}")
    nil
  end
  
end

# Usage Example (e.g., in a controller or background job):
# ExchangeRateService.fetch_exchange_rate('USD', 'KRW', 14)
