Rails.application.routes.draw do
  devise_for :users do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :sends, only: [:index]
  resources :followees
  # Defines the root path route ("/")
  root "sends#index"
end
