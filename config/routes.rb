Rails.application.routes.draw do
  get "signals/index"
  get "settings/index"
  get "settings/upbit_api_setting"
  post "settings/upbit_api_setting_create"
  post "settings/upbit_api_setting_update"


  root 'pages#home'
  get "upbit/index"
  get 'upbit/accounts', to: 'upbit#accounts'
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
end
