require 'net/http'
require 'uri'
require 'json'

class HangukApiService
  BASE_URL = 'https://openapi.koreainvestment.com:9443'
  
  def initialize(api_key: nil, api_secret: nil, account_number: nil, account_code: nil)
    @api_key = api_key
    @api_secret = api_secret
    @account_number = account_number
    @account_code = account_code
    @access_token = nil
  end

  # 예수금 조회
  def get_deposit_info
    endpoint = '/uapi/domestic-stock/v1/trading/inquire-psbl-order'
    
    params = {
      CANO: @account_number,
      ACNT_PRDT_CD: @account_code,
      PDNO: "",
      ORD_UNPR: "",
      ORD_DVSN: "02", # 시장가
      CMA_EVLU_AMT_ICLD_YN: "N",
      OVRS_ICLD_YN: "N"
    }

    headers = {
      "Content-Type" => "application/json",
      "authorization" => "Bearer #{access_token}",
      "appKey" => @api_key,
      "appSecret" => @api_secret,
      "tr_id" => "TTTC8908R",
      "custtype" => "P",
    }

    response = make_request(:get, endpoint, params: params, headers: headers)
    JSON.parse(response.body)
  end

  private

  def access_token
    return @access_token if @access_token

    endpoint = '/oauth2/tokenP'
    
    params = {
      grant_type: 'client_credentials',
      appkey: @api_key,
      appsecret: @api_secret
    }

    response = make_request(:post, endpoint, body: params)
    data = JSON.parse(response.body)
    @access_token = data['access_token']
  end

  def make_request(method, endpoint, params: nil, headers: {}, body: nil)
    uri = URI.parse("#{BASE_URL}#{endpoint}")
    
    if method == :get && params
      uri.query = URI.encode_www_form(params)
    end

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = case method
    when :get
      Net::HTTP::Get.new(uri)
    when :post
      Net::HTTP::Post.new(uri)
    end

    headers.each do |key, value|
      request[key] = value
    end

    request.body = body.to_json if body

    response = http.request(request)
    
    unless response.is_a?(Net::HTTPSuccess)
      raise "API 요청 실패: #{response.code} - #{response.body}"
    end

    response
  end
end 