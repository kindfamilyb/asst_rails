# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  def google_oauth2
    user = User.from_omniauth(auth)
    puts "유저정보1 #{user.id}"

    if user.present?
      sign_out_all_scopes
      flash[:success] = t 'devise.omniauth_callbacks.success', kind: 'Google'
      sign_in user, event: :authentication
      user.update(logined_yn: 'Y')
      user.remember_me!
      puts "유저정보2 #{user.id}"

      if user.has_upbit_api_key?
        # upbit_accounts_path 로 이동
        redirect_to upbit_accounts_path
      else
        # API 키가 없으면 다른 경로로 리다이렉트하거나 메시지를 표시
        flash[:alert] = 'Upbit API 키가 등록되어 있지 않습니다.'
        redirect_to root_path # 적절한 경로로 변경
      end
    else
      flash[:alert] =
        t 'devise.omniauth_callbacks.failure', kind: 'Google', reason: "#{auth.info.email} is not authorized."
      redirect_to new_user_session_path
      puts "유저정보3 #{user.id}"
    end
  end

  # More info at:
  # https://github.com/heartcombo/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end

  protected

  def after_omniauth_failure_path_for(_scope)
    new_user_session_path
  end

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || root_path
  end

  private

  # def from_google_params
  #   @from_google_params ||= {
  #     uid: auth.uid,
  #     email: auth.info.email,
  #     full_name: auth.info.name,
  #     avatar_url: auth.info.image
  #   }
  # end

  def auth
    @auth ||= request.env['omniauth.auth']
  end
end
