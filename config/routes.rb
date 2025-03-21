Rails.application.routes.draw do
  post '/login', to: 'authentication#login'
  delete '/logout', to: 'authentication#logout'
  post '/signup', to: 'authentication#signup'
  get '/current_user', to: 'users#show_current_user'
  resources :friend_requests, only: [:create, :index] do
    member do
      patch :accept
      patch :reject
      delete :cancel
    end
  end
  delete '/unfriend/:friend_id', to: 'friend_requests#unfriend', as: :unfriend
  resources :users, only: [:index ,:show] do
    member do
      get :friends
    end
  end
  resources :posts, only: [:create, :index, :show, :update, :destroy] do
    resources :comments, only: [:create,:update, :destroy] do
      resources :comment_likes, only: [:create, :destroy]
    end
    resources :likes, only: [:create, :destroy] do
      get :liked_users, on: :collection
    end
  end
end