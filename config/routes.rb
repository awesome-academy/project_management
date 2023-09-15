Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi|jp/ do
    root "dashboard#index"
    get    "/login",   to: "sessions#new"
    post   "/login",   to: "sessions#create"
    delete "/logout",  to: "sessions#destroy"
    resources :projects
    resources :projects, only: :show do
      resources :month_project_features, only: :index
      member do
        resources :project_users, only: %i(new create)
      end
    end
    resources :project_users, only: %i(destroy edit update)
    resources :password_resets, only: %i(new create edit update)
    resources :resources
    resources :users, only: %i(edit update)
    resources :reports
    resources :release_plans
    resources :project_features
    resources :health, only: %i(new create)
  end
end
