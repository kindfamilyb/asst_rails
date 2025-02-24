
class PagesController < ApplicationController
  before_action :redirect_unless_logged_in

  def home
    if current_user.present?
      @user_id = current_user.id
      @api_keys = ApiKey.where(user_id: @user_id)
    
    end
    
    @data = [
      ["Jan 1", 10],
      ["Jan 2", 15],
      ["Jan 3", 7],
      ["Jan 4", 12]
    ]
  end

  def redirect_unless_logged_in
    unless user_signed_in?
      redirect_to new_user_session_path
    end
  end
end
