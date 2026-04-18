Rails.application.routes.draw do
  mount MissionControl::Jobs::Engine, at: "/jobs"

  resources :documents, only: [ :index, :update ] do
    member do
      get :thumbnail
    end
  end
  resources :tags, only: [ :index, :show ]
  resources :scans, only: [ :create ]
  resources :duplicates, only: [ :index ]
  get "browse" => "browse#index", as: :browse
  root "documents#index"
end
