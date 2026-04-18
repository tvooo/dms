Rails.application.routes.draw do
  mount MissionControl::Jobs::Engine, at: "/jobs"

  resources :documents, only: [ :index ] do
    member do
      get :thumbnail
    end
  end
  get "browse" => "browse#index", as: :browse
  get "tags"   => "tags#index",   as: :tags
  root "documents#index"
end
