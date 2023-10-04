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
        resources :project_slack_settings, only: %i(new create)
      end
    end
    resources :project_users, only: %i(destroy edit update)
    resources :password_resets, only: %i(new create edit update)
    resources :resources
    resources :users, only: %i(edit update)
    resources :reports
    resources :release_plans do
      collection do
        resources :statistics_release_plans, only: :index
      end
    end
    resources :project_features do
      collection do
        get :plans
      end
    end
    resources :health, only: %i(new create edit update)
    resources :value_resources, only: :index
    resources :health_items
    resources :lesson_learns
    resources :statistics_resources, only: :index
    resources :dashboard_resources, only: :index
    resources :statistics_values, only: :index
    resources :statistics_groups, only: :index
    resources :dashboard_values, only: :index
  end
end
