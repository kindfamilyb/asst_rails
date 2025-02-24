class SettingsController < ApplicationController
  before_action :redirect_unless_logged_in
  before_action :authenticate_user!
  # before_action :params_check

  def index
  end

  def upbit_api_setting
    @user = current_user
    @api_setting = ApiKey.where(user_id: @user.id)

    @upbit_api_setting = @api_setting.where(platform: 'upbit').first
    @hanguk_api_setting = @api_setting.where(platform: 'hanguk').first



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
    @user = current_user
    @upbit_api_setting = ApiKey.where(user_id: @user.id)
    
    @api_key.update_all(
      access_key: params[:access_key],
      secret_key: params[:secret_key]
    )

    render partial: 'api_key_info', locals: { upbit_api_setting: @upbit_api_setting }
  end


  def hanguk_api_setting
    @user = current_user
    @api_setting = ApiKey.where(user_id: @user.id)

    @upbit_api_setting = @api_setting.where(platform: 'upbit').first
    @hanguk_api_setting = @api_setting.where(platform: 'hanguk').first

    render :settings_hanguk_api_setting
  end


  def hanguk_api_setting_create
    @user = current_user
    ApiKey.create(
      user_id: @user.id, 
      access_key: params[:app_key], 
      secret_key: params[:secret_key]
    )
    redirect_to hanguk_accounts_path
  end

  def hanguk_api_setting_update
    @user = current_user
    @hanguk_api_setting = ApiKey.find_by(user_id: @user.id)
    
    @api_key.update_all(
      access_key: params[:access_key],
      secret_key: params[:secret_key]
    )

    render partial: 'api_key_info', locals: { hanguk_api_setting: @hanguk_api_setting }
  end

  private

  def redirect_unless_logged_in
    unless user_signed_in?
      redirect_to new_user_session_path
    end
  end
end