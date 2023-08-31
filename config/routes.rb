Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi|jp/ do
    root "dashboard#index"
    get    "/login",   to: "sessions#new"
    post   "/login",   to: "sessions#create"
    delete "/logout",  to: "sessions#destroy"
    resources :password_resets, only: %i(new create edit update)
    resources :projects, only: %i(index show)
    resources :resources, only: :index
  end
end
