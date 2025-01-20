class SettingsController < ApplicationController

  before_action :authenticate_user!
  # before_action :params_check

  def index
  end

  def upbit_api_setting
    @user = current_user
    @upbit_api_setting = ApiKey.find_by(user_id: @user.id)

    render :settings_upbit_api_setting
  end


  def upbit_api_setting_create
    @user = current_user
    # raise 로 이미 있다면 '이미 있습니다.' 출력
    raise '이미 등록되어 있습니다.' if ApiKey.find_by(user_id: @user.id).present?

    ApiKey.create(
      user_id: @user.id, 
      access_key: params[:access_key], 
      secret_key: params[:secret_key]
      )

    redirect_to upbit_accounts_path
  end

  def upbit_api_setting_update
  end

  # private

  # # 파라미터 검증 메소드
  # def params_check
  #   params.require(:api_key).permit(:access_key, :secret_key)
  # end

end
