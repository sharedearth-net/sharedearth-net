Sharedearthapp::Application.routes.draw do

  resources :items do
    member do
      put "mark_as_normal"
      put "mark_as_lost"
      put "mark_as_damaged"
    end
  end

  resources :people, :only => [:show, :edit, :update] do
    member do
      post "request_trusted_relationship"
      delete "cancel_request_trusted_relationship"
    end
  end
  
  # post "people_network/confirm_request/:people_network_request_id", :to => "people_network#create", :as => "confirm_request"
  # resources :people_network, :only => [] do
  # end

  resources :item_requests, :except => [:index, :destroy, :edit], :path => "requests", :as => "requests" do
    member do
      put "accept"
      put "reject"
      put "complete"
      put "cancel"
      put "collected"
    end
  end
  
  match "/auth/:provider/callback" => "sessions#create"
  match "/auth/:provider" => "sessions#create", :as => :signin # this is dummy route, since this will be handled by OmniAuth
  match "/signout" => "sessions#destroy", :as => :signout

  match "/dashboard", :to => "pages#dashboard"

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
