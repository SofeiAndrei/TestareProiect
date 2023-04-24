Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  root 'static_pages#home'
  get '/help', to: 'static_pages#help', as: 'helf'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :users do
    member do
      get :following, :followers  # este o ruta de genul users/1/following, adica o ruta individuala per membru
    end
    # collection do   # exista si collection in loc de member, care sunt rute de genul users/sofeis
    #   get :sofeis
    # end
  end
  resources :account_activations, only: [:edit] # creeaza doar ruta account_activations/edit
  resources :password_resets, only: %i[new create edit update] # %i[array] -> array de simboluri
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end