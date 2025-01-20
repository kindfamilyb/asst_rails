source "https://rubygems.org"

gem "rails", "~> 7.2.1"
gem "sprockets-rails"
gem "pg", "~> 1.1"
gem 'pgvector', '~> 0.3.2' # pgvector를 ActiveRecord와 함께 사용하기 위한 gem
gem 'dotenv-rails', groups: [:development, :test] # 환경 변수 관리를 위한 gem

gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ mswin mswin64 mingw x64_mingw jruby ]
gem "bootsnap", require: false

# 추가한 gem
gem 'omniauth-google-oauth2'
gem "omniauth-rails_csrf_protection"
gem 'devise'
gem 'devise-jwt'
gem 'jsonapi-serializer'
gem 'rack-cors'
gem 'jwt'
gem 'httparty'
gem "debug"
gem 'whenever', require: false
gem 'redis'
gem 'redis-rails'
gem "sidekiq"
gem "sidekiq-scheduler", "~> 5.0"
# 차트 관련 gem
gem 'chartkick'
# 만약 날짜별 그룹화 기능이 필요하다면 다음도 추가
gem 'groupdate'
gem 'yfinance'
gem 'yahoo-finance'
gem 'addressable'  # URI encoding을 위한 gem
# gem 'alpha_vantage'


# gem "pry"
# gem "pry-rails"



group :development, :test do
  # gem "debug", platforms: %i[ mri mswin mswin64 mingw x64_mingw ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "web-console"
  gem "error_highlight", ">= 0.4.0", platforms: [:ruby]
  gem 'iruby', require: false
  gem 'ffi-rzmq', require: false
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
