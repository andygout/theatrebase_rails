Rails.application.routes.draw do

  match "/404", :to => "errors#error_404", :via => :all
  match "/500", :to => "errors#error_500", :via => :all

  root 'productions#index'

  get     'log_in'   =>  'sessions#new'
  post    'log_in'   =>  'sessions#create'
  delete  'log_out'  =>  'sessions#destroy'

  get     'productions/:id/:url/edit' => 'productions#edit',    as: :edit_production
  get     'productions/:id/:url'      => 'productions#show',    as: :production
  patch   'productions/:id/:url'      => 'productions#update'
  put     'productions/:id/:url'      => 'productions#update'
  delete  'productions/:id/:url'      => 'productions#destroy'

  resources :productions, only: [:new, :create, :index]
  resources :users
  resources :admin_status, param: :user_id, only: [:edit, :update]
  resources :suspension_status, param: :user_id, only: [:edit, :update]
  resources :account_activations, only: [:edit, :update]
  resources :password_resets, only: [:new, :create, :edit, :update]

end
