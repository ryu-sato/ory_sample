# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  root 'photos#index'

  get 'authorize', to: 'authorizations#authorize'
  get 'callback', to: 'authorizations#callback'
  resources :photos, only: %i[index show]
end
