# app/jobs/fetch_exchange_rates_job.rb

class FetchUpdateAlphaVantageExchangeRatesJob < ApplicationJob
    # queue_as :default  # 사용하고자 하는 큐 이름(백엔드에 따라 다름)
  
    # base_currency, target_currency 등을 파라미터로 받아서 유연하게 처리할 수 있음
    def perform(base_currency: "USD", target_currency: "KRW")
      # 1) Service 호출 (예시: YahooFinanceService)
      rates_data = AlphaVantageService.fetch_exchange_data(
        base_currency: base_currency,
        target_currency: target_currency,
        start_date: 1.month.ago.to_date,
        end_date: Date.today
      )
  
      # 2) DB에 저장
      rates_data.each do |rate|
        ExchangeRate.find_or_create_by!(
          base_currency: base_currency,
          target_currency: target_currency,
          date: rate[:date]
        ) do |record|
          record.open   = rate[:open]
          record.high   = rate[:high]
          record.low    = rate[:low]
          record.close  = rate[:close]
          record.volume = rate[:volume]
        end
      end
  
      Rails.logger.info "Successfully fetched #{base_currency}/#{target_currency} exchange rates from Yahoo Finance."
    end
  end
  