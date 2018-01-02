Rails.application.routes.draw do

  get 'fetch/shopify'
  resources :reviews

end
