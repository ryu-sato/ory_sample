# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  get 'login', to: 'authentications#new'
  get 'logout', to: 'authentications#logout'
  get 'consent', to: 'authorizations#new'
  post 'consent', to: 'authorizations#create'
  resources :authentications, only: %i[new create destroy]
  resources :authorizations, only: %i[new create]

  root 'photos#index'
  resources :photos

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :photos, only: %i[index show]
    end
  end
end
