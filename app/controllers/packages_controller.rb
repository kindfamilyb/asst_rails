class PackagesController < ApplicationController
  before_action :redirect_unless_logged_in
  before_action :authenticate_user!

  def index
    # 여기에 로직을 추가하세요
    @packages = Package.all
    @user_id = current_user.id
  end

  def download
    @package = Package.find(params[:package_id])
    user_id = current_user.id

    service = Upbit::PackageService.new
    service.create_my_strategy_infos(package_id: @package.package_id, user_id: user_id)
    @package.download_count += 1
    @package.save

    redirect_to upbit_accounts_path
  end

  def update_active_yn
    @package = Package.find(params[:package_id])
    @package_my_strategy_infos = MyStrategyInfo.where(package_id: @package.package_id, user_id: current_user.id)

    @package_my_strategy_infos.each do |package_my_strategy_info|
      if package_my_strategy_info.active_yn == 'Y'
        package_my_strategy_info.active_yn = 'N'
      else
        package_my_strategy_info.active_yn = 'Y'
      end
      package_my_strategy_info.save
    end
    
    redirect_to upbit_accounts_path
  end

  def show
    @package = Package.find(params[:id])
  end

  private

  def redirect_unless_logged_in
    unless user_signed_in?
      redirect_to new_user_session_path
    end
  end
end 
