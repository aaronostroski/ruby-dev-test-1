Rails.application.routes.draw do
  mount GoodJob::Engine => "good_job"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "site/home#index"
  get "home" => "site/home#index", as: :home

  namespace :site do
    resources :folders, except: [ :index, :show ] do
      member do
        get :download
      end
    end
    resources :archives, except: [ :index, :show ] do
      member do
        get :download
      end
    end
    resources :export_files, only: [ :index ] do
      member do
        get :download
      end
    end
  end
end
