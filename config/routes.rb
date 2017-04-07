Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root 'welcome#index'

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      post 'webhooks/smooch' => 'webhooks#smooch'
      get 'conversations/search' => 'conversations#search'
      resources :conversations, only: [:index, :show]
      resources :messages, only: [:index, :show]
    end
  end

end
