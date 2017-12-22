Rails.application.routes.draw do
  get 'fetch/shopify'

  resources :reviews

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
