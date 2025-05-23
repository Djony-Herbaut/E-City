Rails.application.routes.draw do

  resources :transports, only: [:index, :show, :edit, :update], controller: 'transports'
  get 'horaires', to: 'transports#schedules', as: :horaires
  resources :transports, only: [:index, :show, :edit, :update], controller: 'transports' do
    member do
      post :report_incident
    end
  end

  resources :locations do
    resources :reservations, except: [:index] do
      collection do
        get :horaires  
      end
      member do
        post :report_incident  
      end
    end
  end
  resources :reservations, only: [:index] 
  
  namespace :admin do
    resources :reservations, only: [:index, :update]
  end
  
  get "objet_connectes/index"
  
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
    resources :objet_connectes, only: [:index, :new, :create, :show, :destroy]
  end

  resources :actualites

  resources :objet_connectes
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

end
