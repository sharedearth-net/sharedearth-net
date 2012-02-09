Sharedearthapp::Application.routes.draw do
  resources :transparency, :only => [:index] do
    collection do
      put 'accept_tr'
    end
  end

  ActiveAdmin.routes(self)

  resources :fb_friends, :only => [:index]
  get 'findtheothers'     => "fb_friends#index"
  get 'search_fb_friends' => "fb_friends#search_fb_friends"
  get 'search_people'     => "fb_friends#search_people"

  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_scope :admin_user do
    get '/admin/logout', :to => 'active_admin/devise/sessions#destroy'
end



  resources :terms, :only => [:index] do
    collection do
      put 'accept_tc'
      put 'accept_pp'
      get 'principles'
    end
  end

  resources :legal_notices, :only => [:index] do
    collection do
      put 'accept_legal_notice'
      put 'accept_pp'
      get 'principles'
    end
  end

   resources :requested_invitations, :only => [:create]

  #resources :requested_invitations, :only => [ :create ]
    #post "reguested_invitations/create"

  resources :comments, :only => [:create]

  resources :invitations, :except => [:destroy, :edit, :show, :new]

  get "invitations/validate"
  get "invitations/purge"
  get "invitations/preview"
  get "invitations/switch"
  get "invitations/invite"

  get "people/cancel/:id" => "people#cancel"

  get "search/index"

  resources :items do
    member do
      put "mark_as_normal"
      put "mark_as_lost"
      put "mark_as_damaged"
			put "mark_as_hidden"
      put "mark_as_unhidden"
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
      put "recall"
      put "return"
      put "acknowledge"
      put "cancel_recall"
      put "cancel_return"
      post 'new_comment'
    end
    resources :feedbacks
  end



  match "/auth/:provider/callback" => "sessions#create"
  match "/signout" => "sessions#destroy", :as => :signout

  match "/dashboard", :to => "pages#dashboard"
  match "/principles", :to => "terms#principles"
  match '/about' => 'pages#about'
  match '/contribute' => 'pages#contribute'
  match '/no_javascript' => 'pages#no_javascript'
  match '/collect_email' => 'pages#collect_email'

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

  match '*a', :to => 'application#missing_route'   #Catch wrong route problem
end
