ActionController::Routing::Routes.draw do |map|
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.resources :users, :collection => {:reset_passwords => :get}

  map.resource :session

  map.resources :vod_files

  map.resources :vod_formats

  map.resources :vods

  map.resources :reference_logs

  map.resources :tapes

  map.resources :channels do |ch|
		ch.resources :playlists, :as => 'playlist', :collection => {:schedule => :get, :next => :get, :gdata => :get, :timeline => :get}
	end

  map.resources :program_descriptions

  map.resources :program_categories
  
  map.resources :playlists

  map.resources :programs, :collection => {:import => :get, :autocomplete => :get, :vods => :get, :update_files => :post, :nextvod => :get, :voddone => :get}, :member => {:print => :get}
	
  map.resources :runlists, :member => {:up => :get, :down => :get }

	map.link_program 'programs/:id/link/:subprog_id', :controller => 'programs', :action => 'link'
	map.unlink_program 'programs/:id/unlink/:subprog_id', :controller => 'programs', :action => 'unlink'
	map.move_program_up 'programs/:id/moveup/:subprog_id', :controller => 'programs', :action => 'move', :dir => "up"
	map.move_program_down 'programs/:id/movedown/:subprog_id', :controller => 'programs', :action => 'move', :dir => "down"

	map.ical 'info/:channel', :controller => 'info', :action => 'ical'


  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "elaine"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
