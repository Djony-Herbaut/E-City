Rails.application.routes.draw do
  
  namespace :admin do
    get "dashboard/index"
  end

  get "pages/e_city_histoire"
  get 'notre-histoire', to: 'pages#e_city_histoire'
  get "users/show"
  get 'mon_profil', to: 'users#show', as: :user_profile
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :actualites
  get "home/index"
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  root to: "home#index" # root to contrôleur Home avec une action index

  namespace :admin do
    
    root to: "dashboard#index" # Panel admin home
    resources :objet_connectes, only: [:index, :update]
  end
  resources :actualites
end
