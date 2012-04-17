Hrwa::Application.routes.draw do

  devise_for :admins

  # Our Blacklight stuff (before Blacklight adds its own routes)
  match '/search'  => 'catalog#index'
  match '/site_detail/:bib_key'  => 'catalog#site_detail'
  match '/crawl_calendar/:bib_key'  => 'catalog#crawl_calendar'

  Blacklight.add_routes(self)

  # Static pages - no dynamic content at all
  match '/about'       => 'static#about'
  match '/browse'      => 'static#collection_browse'
  match '/owner_nomination'      => 'static#owner_nomination'
  match '/public_nomination'      => 'static#public_nomination'
  match '/public_feedback'      => 'static#public_feedback'
  match '/public_bugreports'      => 'static#public_bugreports'

  # Internal stuff
  match '/internal/seed_list' => 'internal#seed_list'

  # Admin controller
  match '/admin'      => 'admin#index'

  # TODO: TEMPORARY STUFF FOR DEV; REMOVE LATER
  match '/advanced_asf',      :to => redirect( '/advanced_asf.html' )
  match '/advanced_fsf',      :to => redirect( '/advanced_fsf.html' )
  match '/internal_feedback', :to => redirect( '/internal_feedback.html' )


  resources :catalog, :only => [:index, :show, :update], :id => /.+/

  root :to => "static#index"

  # Devise Login Options
  #devise_for :users
  devise_for :admins, :path => "admin", :path_names => { :sign_in => 'login', :sign_out => 'logout'}
  as :admin do
    get 'admin/login' => 'devise/sessions#new', :as => :admin_login
    get 'admin/logout' => 'devise/sessions#destroy', :as => :admin_logout
  end

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
