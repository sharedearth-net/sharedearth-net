Sharedearthapp::Application.routes.draw do

  resources :transparency, :only => [:index]

  ActiveAdmin.routes(self)
  


  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_scope :admin_user do
    get '/admin/logout', :to => 'active_admin/devise/sessions#destroy'
end

  get "reguested_invitations/create"
  
  resources :terms, :only => [:index] do
    collection do
      put 'accept_tc'
      put 'accept_pp'
      get 'principles'
    end
  end
  
  resources :comments, :only => [:create]

  resources :invitations, :except => [:destroy, :edit, :show, :new]
  
  get "invitations/validate"
  get "invitations/purge"
  get "invitations/preview"
  get "invitations/switch"

  get "search/index"

  resources :items do
    member do
      put "mark_as_normal"
      put "mark_as_lost"
      put "mark_as_damaged"
    end
  end

  resources :people, :only => [:show, :edit, :update, :index, :destroy] do
    member do 
      get :network
      get :my_network
    end
  end
    
  resources :people_network_requests, :only => [:create, :destroy] do
    member do
      put "confirm"
      put "deny", :action => :destroy
    end
  end

  resources :people_network, :only => [ :destroy ]
  
  resources :item_requests, :except => [:index, :destroy, :edit], :path => "requests", :as => "requests" do
    member do
      put "accept"
      put "reject"
      put "complete"
      put "cancel"
      put "collected"
    end
    resources :feedbacks
  end
  
  match "/auth/:provider/callback" => "sessions#create"
  match "/signout" => "sessions#destroy", :as => :signout

  match "/dashboard", :to => "pages#dashboard"
  match "/principles", :to => "terms#principles"
  match '/about' => 'pages#about'

  root :to => "pages#index"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
