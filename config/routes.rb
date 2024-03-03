Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :admin, only: :index

  namespace :admin do
    resources :invoices, only: [:index, :show, :update]
  end

  namespace :admin do
    resources :merchants, except: [:destroy]
  end

  resources :merchants do 
    # resources :dashboard, as: "merchant_dashboard"
    member { get "dashboard" }
    resources :items, controller: 'merchant_items', only: [:index, :show, :edit, :update, :new, :create]
    resources :invoices, controller: 'merchant_invoices', only: [:index, :show]
    resources :discounts, controller: 'merchant_discounts'
  end
  
  get "/", to: "welcome#index"
  resources :invoices, controller: "merchant_invoices"

end
