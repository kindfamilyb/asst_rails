Rails.application.routes.draw do
  
  root 'pages#home'
  get "upbit/index"
  get 'upbit/accounts', to: 'upbit#accounts'
  get 'posts/index'
  
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
