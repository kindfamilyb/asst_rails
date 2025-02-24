class HangukController < ApplicationController
  before_action :redirect_unless_logged_in

  def account
    user_id = current_user.id
    api_keys = ApiKey.where(user_id: user_id).where(platform: 'hanguk').first
    api_key = api_keys.api_key
    api_secret = api_keys.api_secret
    account_number = api_keys.account_number
    account_code = api_keys.account_code

    api_service = HangukApiService.new(
      api_key: api_key,
      api_secret: api_secret,
      account_number: account_number,
      account_code: account_code
    )

    @deposit_info = api_service.get_deposit_info
  rescue => e
    flash.now[:error] = "예수금 정보 조회 중 오류가 발생했습니다: #{e.message}"
  end

  private

  def redirect_unless_logged_in
    unless user_signed_in?
      redirect_to new_user_session_path
    end
  end
end
