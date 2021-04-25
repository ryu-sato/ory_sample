# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  root 'photos#index'

  # resources
  resources :photos

  # API
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :photos, only: %i[index show]
    end
  end

  # OpenID Connect ID Provider
  namespace :sso do
    get 'login', to: 'authentications#new'
    post 'login', to: 'authentications#create'
    # delete 'logout', to: 'authentications#destroy'

    get 'consent', to: 'authorizations#new'
    post 'consent', to: 'authorizations#create'
  end
end
