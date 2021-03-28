# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  root 'photos#index'
  resources :photos

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :photos, only: %i[index]
    end
  end
end
