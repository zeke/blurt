Blurt::Application.routes.draw do

  devise_for :users

  resources :games, :format => :json, :only => [:index] do
    resources :guesses, :controller => 'guesses', :only => [:create], :format => :json
  end

  root :to => 'static#index'
  
end
