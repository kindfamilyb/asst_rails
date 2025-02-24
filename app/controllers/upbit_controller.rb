require 'jwt'
require 'securerandom'

class UpbitController < ApplicationController
  before_action :redirect_unless_logged_in
  before_action :bitcoin_price
  before_action :authenticate_user!

  def index
  end

  def bitcoin_price
    url = "https://api.upbit.com/v1/ticker?markets=KRW-BTC"
    response = HTTParty.get(url)
    
    puts response

    if response.code == 200
      ticker_data = response.parsed_response.first
      @bitcoin_price = {
        market: ticker_data['market'],              # 거래 시장 (예: KRW-BTC)
        trade_price: ticker_data['trade_price'],    # 현재 거래 가격
        high_price: ticker_data['high_price'],      # 고가
        low_price: ticker_data['low_price'],        # 저가
        timestamp: Time.at(ticker_data['timestamp'] / 1000) # 데이터 시간
      }

      @btc_price = @bitcoin_price[:trade_price]
    else
      @error = "Failed to fetch Bitcoin price data: #{response.code}"
    end




  end

  def accounts
    user_id = current_user.id
    api_keys = ApiKey.where(user_id: user_id).where(platform: 'upbit').first

    access_key = api_keys.access_key
    secret_key = api_keys.secret_key

    nonce = SecureRandom.uuid
    payload = {
      access_key: access_key,
      nonce: nonce
    }

    jwt_token = JWT.encode(payload, secret_key, 'HS256')

    url = "https://api.upbit.com/v1/accounts"
    headers = { "Authorization" => "Bearer #{jwt_token}" }

    response = HTTParty.get(url, headers: headers)
    @current_bitcoin_redis_price = RedisService.get('current_bitcoin_redis_price')

    if response.code == 200
      accounts = response.parsed_response
      @krw_account = accounts.select { |a| a["currency"] == "KRW" }
      @krw_balance = @krw_account.map { |a| a["balance"] }[0].to_i

      @btc_account = accounts.select { |a| a["currency"] == "BTC" }
      @btc_balance = @btc_account.map { |a| a["balance"] }[0]
      @btc_avg_buy_price = @btc_account.map { |a| a["avg_buy_price"] }[0]
      @btc_currency = @btc_account.map { |a| a["currency"] }[0]
      
      # 매수 금액 계산
      @btc_buy_value = @btc_balance.to_f * @btc_avg_buy_price.to_f

      # 현재 평가금액 계산 balance * bitcoin_currnet_price
      @btc_currnet_value = @btc_balance.to_f * @bitcoin_price[:trade_price]

      # # 수익률 계산 (매수 금액이 0이 아닌 경우에만)
      @btc_profit_rate = @btc_buy_value - @btc_currnet_value  != 0 ? (((@btc_currnet_value - @btc_buy_value) / @btc_buy_value) * 100).round(2) : 0

      # 비트코인평가금액 = 현재가격 * 비트코인 보유량
      
      
    end

    @my_strategy_infos = MyStrategyInfo.where(user_id: current_user.id).order(created_at: :asc)

    @total_profit_rate = calculate_total_profit_rate
    # 주문 내역 조회
    @orders = fetch_orders

    # 현재 비트코인 가격 조회
    url = "https://api.upbit.com/v1/ticker?markets=KRW-BTC"
    response = HTTParty.get(url)
    
    puts response

    if response.code == 200
      ticker_data = response.parsed_response.first
      @bitcoin_price = {
        market: ticker_data['market'],              # 거래 시장 (예: KRW-BTC)
        trade_price: ticker_data['trade_price'],    # 현재 거래 가격
        high_price: ticker_data['high_price'],      # 고가
        low_price: ticker_data['low_price'],        # 저가
        timestamp: Time.at(ticker_data['timestamp'] / 1000) # 데이터 시간
      }

      @now_price = @bitcoin_price[:trade_price]

      @price_history_comparison = upbit_price_history_comparison
      
    end
  end

  # upbit 가격 52주일전종가, 중간일자, 어제종가를 비교해서 상승, 하락 출력
  
  def upbit_price_history_comparison
    market = "KRW-BTC"
    
    # 현재 시간 기준으로 365일 전 날짜 계산
    today = Time.now
    one_year_ago = today - 365.days
    six_month_ago = today - 182.days # 중간 일자 (약 6개월 전)
    # 3개월전 날짜 계산
    three_month_ago = today - 90.days
    # 1개월전 날짜 계산
    one_month_ago = today - 30.days

    # 월의 중간 일자 계산
    middle_of_month = today - 15.days

    # 3일전 종가 조회
    three_days_ago = today - 3.days

    # 1주일전 날짜 계산
    one_week_ago = today - 7.days


    
    # 각 날짜의 일봉 데이터 조회
    url = "https://api.upbit.com/v1/candles/days"
    
    # 365일 전 종가 조회
    one_year_ago_response = HTTParty.get("#{url}?market=#{market}&to=#{one_year_ago.strftime('%Y-%m-%d')}T00:00:00Z&count=1")
    
    # 6개월전 종가 조회
    six_month_ago_date_response = HTTParty.get("#{url}?market=#{market}&to=#{six_month_ago.strftime('%Y-%m-%d')}T00:00:00Z&count=1")
    
    # 3개월전 종가 조회
    three_month_ago_date_response = HTTParty.get("#{url}?market=#{market}&to=#{three_month_ago.strftime('%Y-%m-%d')}T00:00:00Z&count=1")
    
    # 1개월전 종가 조회
    one_month_ago_date_response = HTTParty.get("#{url}?market=#{market}&to=#{one_month_ago.strftime('%Y-%m-%d')}T00:00:00Z&count=1")
    
    # 월의 중간 일자 종가 조회
    middle_of_month_date_response = HTTParty.get("#{url}?market=#{market}&to=#{middle_of_month.strftime('%Y-%m-%d')}T00:00:00Z&count=1")
    
    # 1주일전 종가 조회
    one_week_ago_date_response = HTTParty.get("#{url}?market=#{market}&to=#{one_week_ago.strftime('%Y-%m-%d')}T00:00:00Z&count=1")

    # 3일전 종가 조회
    three_days_ago_date_response = HTTParty.get("#{url}?market=#{market}&to=#{three_days_ago.strftime('%Y-%m-%d')}T00:00:00Z&count=1")

    url = "https://api.upbit.com/v1/ticker?markets=KRW-BTC"
    response = HTTParty.get(url)
    
    puts response

    if response.code == 200
      ticker_data = response.parsed_response.first
      bitcoin_price = {
        market: ticker_data['market'],              # 거래 시장 (예: KRW-BTC)
        trade_price: ticker_data['trade_price'],    # 현재 거래 가격
        high_price: ticker_data['high_price'],      # 고가
        low_price: ticker_data['low_price'],        # 저가
        timestamp: Time.at(ticker_data['timestamp'] / 1000) # 데이터 시간
      }

      now_price = bitcoin_price[:trade_price]
    end

    price_history_comparison = {}

    # 1년전 종가 비교
    if one_year_ago_response[0]['trade_price'] < six_month_ago_date_response[0]['trade_price'] && six_month_ago_date_response[0]['trade_price'] < now_price
      one_year_history_comparison = 1
    elsif one_year_ago_response[0]['trade_price'] > six_month_ago_date_response[0]['trade_price'] && six_month_ago_date_response[0]['trade_price'] > now_price
      one_year_history_comparison = -1
    else
      one_year_history_comparison = 0
    end

    # 6개월전 종가 비교
    if six_month_ago_date_response[0]['trade_price'] < three_month_ago_date_response[0]['trade_price'] && three_month_ago_date_response[0]['trade_price'] < now_price
      six_month_history_comparison = 1
    elsif six_month_ago_date_response[0]['trade_price'] > three_month_ago_date_response[0]['trade_price'] && three_month_ago_date_response[0]['trade_price'] > now_price
      six_month_history_comparison = -1
    else
      six_month_history_comparison = 0
    end

    # 1개월전 종가 비교
    if one_month_ago_date_response[0]['trade_price'].present? && middle_of_month_date_response[0]['trade_price'].present?
      if one_month_ago_date_response[0]['trade_price'] < middle_of_month_date_response[0]['trade_price'] && middle_of_month_date_response[0]['trade_price'] < now_price
        one_month_history_comparison = 1
      elsif one_month_ago_date_response[0]['trade_price'] > middle_of_month_date_response[0]['trade_price'] && middle_of_month_date_response[0]['trade_price'] > now_price
        one_month_history_comparison = -1
      else
        one_month_history_comparison = 0
      end
    else
      one_month_history_comparison = "데이터 없음"
    end

    # 1주일전 종가 비교
    if one_week_ago_date_response[0]['trade_price'] < three_days_ago_date_response[0]['trade_price'] && three_days_ago_date_response[0]['trade_price'] < now_price
      one_week_history_comparison = 1
    elsif one_week_ago_date_response[0]['trade_price'] > three_days_ago_date_response[0]['trade_price'] && three_days_ago_date_response[0]['trade_price'] > now_price
      one_week_history_comparison = -1
    else
      one_week_history_comparison = 0
    end


    price_history_comparison = {
      year: one_year_history_comparison,
      six_month: six_month_history_comparison,
      one_month: one_month_history_comparison,
      one_week: one_week_history_comparison
    }
  end



    # 로그인 여부 확인 후 root로 이동시키는 메소드
  def redirect_unless_logged_in
    unless user_signed_in?
      redirect_to root_path, alert: "로그인이 필요합니다."
    end
  end

  # 토글 버튼으로 요청이 들어오면 my_strategy_info 테이블의 active_yn 컬럼을 업데이트 하는 메소드
  def update_my_strategy_info_active_yn
    my_strategy_info = MyStrategyInfo.find(params[:my_strategy_info_id])
    if my_strategy_info.active_yn == 'Y'
      my_strategy_info.update(active_yn: 'N')
    else
      my_strategy_info.update(active_yn: 'Y')
    end
    redirect_to upbit_accounts_path
  end

  # my_strategy_info_id 값으로 매매한 내역을 조회하는 메소드
  def get_trades_by_my_strategy_info_id
    @trades = Trade.where(my_strategy_info_id: params[:my_strategy_info_id])
    render :get_trades_by_my_strategy_info_id
  end

  def update_target_profit_rate
    my_strategy_info = MyStrategyInfo.find(params[:my_strategy_info_id])
    my_strategy_info.update(target_profit_rate: params[:target_profit_rate])
    render json: { success: true }
  end

  def update_trade_account_rate
    my_strategy_info = MyStrategyInfo.find(params[:my_strategy_info_id])
    my_strategy_info.update(trade_account_rate: params[:trade_account_rate])
    render json: { success: true }
  end

  def update_trade_delay_duration
    my_strategy_info = MyStrategyInfo.find(params[:my_strategy_info_id])
    my_strategy_info.update(trade_delay_duration: params[:trade_delay_duration])
    render json: { success: true }
  end

  def delete_my_strategy_info
    my_strategy_info = MyStrategyInfo.find(params[:my_strategy_info_id])
    my_strategy_info.destroy
    redirect_to upbit_accounts_path, notice: '전략이 삭제되었습니다.'
  end

  def create_my_strategy_info
    MyStrategyInfo.create(
      user_id: current_user.id,
      target_profit_rate: 10,
      trade_account_rate: 50,
      trade_delay_duration: 1,
      active_yn: 'N',
      strategy_id: 4,
      asst_name: 'BTC',
      trade_delay_type: 'week'
    )
    render json: { success: true }
  end

  def update_trade_type
    my_strategy_info = MyStrategyInfo.find(params[:my_strategy_info_id])
    my_strategy_info.update(trade_type: params[:trade_type])
    render json: { success: true }
  end

  private

  def calculate_total_profit_rate
    user_id = current_user.id
    api_keys = ApiKey.where(user_id: user_id).where(platform: 'upbit').first
    
    access_key = api_keys.access_key
    secret_key = api_keys.secret_key
    
    url = "https://api.upbit.com/v1/orders/closed"
    
    query = {
      market: "KRW-BTC",
      state: "done",
      page: 1,
      limit: 100,
      order_by: "desc"
    }

    # 쿼리 해시 생성
    query_string = URI.encode_www_form(query)
    query_hash = OpenSSL::Digest::SHA512.hexdigest(query_string)

    # JWT 토큰 생성
    payload = {
      access_key: access_key,
      nonce: SecureRandom.uuid,
      query_hash: query_hash,
      query_hash_alg: 'SHA512'
    }

    jwt_token = JWT.encode(payload, Rails.application.credentials.dig(:upbit, :secret_key), 'HS256')
    
    headers = {
      "Authorization" => "Bearer #{jwt_token}"
    }

    response = HTTParty.get(url, 
      headers: headers,
      query: query
    )

    return 0 unless response.code == 200

    orders = response.parsed_response
    @total_profit = 0
    @total_investment = 0
    
    orders.each do |order|
      executed_volume = order['executed_volume'].to_f
      price = order['price'].to_f
      
      if order['side'] == 'bid'  # 매수
        @total_investment += price * executed_volume
      else  # 매도
        # 매도 시 수익 계산
        avg_price = order['trades_avg_price'].to_f
        @total_profit += (avg_price - price) * executed_volume
      end
    end

    # 현재 보유 중인 BTC의 평가 손익도 포함
    if @btc_balance.to_f > 0
      current_value = @btc_balance.to_f * @bitcoin_price[:trade_price]
      cost_basis = @btc_balance.to_f * @btc_avg_buy_price.to_f
      @total_profit += (current_value - cost_basis)
    end

    return 0 if @total_investment == 0
    ((@total_profit / @total_investment) * 100).round(2)
  end

  # def generate_token
  #   access_key = Rails.application.credentials.dig(:upbit, :access_key)
  #   secret_key = Rails.application.credentials.dig(:upbit, :secret_key)
  #   nonce = SecureRandom.uuid

  #   payload = {
  #     access_key: access_key,
  #     nonce: nonce,
  #     query_hash: nil,
  #     query_hash_alg: nil
  #   }

  #   JWT.encode(payload, secret_key, 'HS256')
  # end

  def fetch_orders
    url = "https://api.upbit.com/v1/orders/closed"
    
    query = {
      market: "KRW-BTC",
      state: "done",
      page: 1,
      limit: 100,
      order_by: "desc"
    }

    # 쿼리 해시 생성
    query_string = URI.encode_www_form(query)
    query_hash = OpenSSL::Digest::SHA512.hexdigest(query_string)

    # JWT 토큰 생성
    payload = {
      access_key: Rails.application.credentials.dig(:upbit, :access_key),
      nonce: SecureRandom.uuid,
      query_hash: query_hash,
      query_hash_alg: 'SHA512'
    }

    jwt_token = JWT.encode(payload, Rails.application.credentials.dig(:upbit, :secret_key), 'HS256')
    
    headers = {
      "Authorization" => "Bearer #{jwt_token}"
    }
    
    # 디버깅을 위한 요청 정보 출력
    Rails.logger.info "Upbit API Request URL: #{url}"
    Rails.logger.info "Upbit API Headers: #{headers}"
    Rails.logger.info "Upbit API Query: #{query}"
    
    response = HTTParty.get(url, 
      headers: headers,
      query: query
    )

    # 응답 상태 및 내용 확인
    Rails.logger.info "Upbit API Response Status: #{response.code}"
    Rails.logger.info "Upbit API Response Body: #{response.body}"

    if response.code != 200
      Rails.logger.error "Upbit API Error: #{response.body}"
      return []
    end

    begin
      orders = JSON.parse(response.body)
      Rails.logger.info "Parsed Orders Count: #{orders.size}"
      
      orders.map do |order|
        {
          created_at: Time.parse(order['created_at']).localtime,
          side: order['side'] == 'ask' ? '매도' : '매수',
          price: order['price'].to_f,
          executed_volume: order['executed_volume'].to_f,
          amount: (order['price'].to_f * order['executed_volume'].to_f).round(0),
          avg_price: order['trades_avg_price'].to_f,
          state: order['state']
        }
      end
    rescue => e
      Rails.logger.error "Error parsing orders: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      []
    end
  end

  def calculate_change_rate(old_price, new_price)
    ((new_price - old_price) / old_price * 100).round(2)
  end

  private

  def redirect_unless_logged_in
    unless user_signed_in?
      redirect_to new_user_session_path
    end
  end

end
