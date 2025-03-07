require 'sidekiq/web'
Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  username == 'admin' && password == 'password123'  # 인증 정보
end


Rails.application.routes.draw do

  get "upbit/trade_custom_package_change", to: 'upbit#trade_custom_package_change', as: 'trade_custom_package_change'
  get "packages/update_active_yn", to: 'packages#update_active_yn', as: 'update_active_yn'
  get "packagemarket/index"
  get "hanguk/account"

  get "settings/hanguk_api_setting", to: 'settings#hanguk_api_setting', as: 'hanguk_api_setting'
  post "settings/hanguk_api_setting", to: 'settings#hanguk_api_setting_create', as: 'hanguk_api_setting_create'
  put "settings/hanguk_api_setting", to: 'settings#hanguk_api_setting_update', as: 'hanguk_api_setting_update'

  mount Sidekiq::Web => '/sidekiq'

  get "signals/index"
  get "settings/index"
  get "settings/upbit_api_setting", to: 'settings#upbit_api_setting', as: 'upbit_api_setting'
  post "settings/upbit_api_setting", to: 'settings#upbit_api_setting_create', as: 'upbit_api_setting_create'
  put "settings/upbit_api_setting", to: 'settings#upbit_api_setting_update', as: 'upbit_api_setting_update'


  root 'pages#home'
  get "upbit/index"
  get 'upbit/accounts', to: 'upbit#accounts'
  # post 'upbit/update_signal_number', to: 'upbit#update_signal_number'
  post 'upbit/update_target_profit_rate', to: 'upbit#update_target_profit_rate'
  post 'upbit/update_trade_account_rate', to: 'upbit#update_trade_account_rate'
  post 'upbit/update_trade_delay_duration', to: 'upbit#update_trade_delay_duration'
  get 'posts/index'
  
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  # 토글 버튼으로 요청이 들어오면 my_strategy_info 테이블의 active_yn 컬럼을 업데이트 하는 메소드
  get 'upbit/update_my_strategy_info_active_yn', to: 'upbit#update_my_strategy_info_active_yn'

  # my_strategy_info_id 값으로 매매한 내역을 조회하는 메소드
  get 'upbit/get_trades_by_my_strategy_info_id', to: 'upbit#get_trades_by_my_strategy_info_id'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  delete 'upbit/delete_my_strategy_info', to: 'upbit#delete_my_strategy_info'

  post 'upbit/create_my_strategy_info', to: 'upbit#create_my_strategy_info'

  post 'upbit/update_trade_type', to: 'upbit#update_trade_type'

  get 'packages/index', to: 'packages#index'
  get 'packages/download', to: 'packages#download'

  resources :packages, only: [:index, :show]
end
