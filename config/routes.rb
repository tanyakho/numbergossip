Numbergossip::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  
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

  get 'index(/:number)' => 'number_gossip#index'
  get 'list' => 'number_gossip#list'
  get 'credits' => 'number_gossip#credits'
  get 'links' => 'number_gossip#links'
  get 'contact' => 'number_gossip#contact'
  get 'editorial_policy' => 'number_gossip#editorial_policy'
  get 'status' => 'number_gossip#status'
  match 'update(/:id)' => 'number_gossip#update', via: [:get, :post]

  # map.connect ':action/:id', :controller => "number_gossip", :requirements => { :action => /index|list|credits|links|contact|editorial_policy|status|update/ }

  # This arrangement permits the system to handle arbitrary paths as
  # attempts to query for numbers, which receive graceful errors.
  get '(:number)' => 'number_gossip#index', :as => :number_page
  # map.number_page ':number', :controller => "number_gossip", :action => "index"

end
