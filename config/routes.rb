Hrwa::Application.routes.draw do

  devise_for :service_users

  DeviseWind.add_routes(self)

  # Our Blacklight stuff (before Blacklight adds its own routes)
  match ':catalog/advanced'        => 'catalog#advanced'
  # Replaces 'catalog' in all urls with 'search'
  resources :catalog, :path => :search

  Blacklight.add_routes(self)

  # Pages controller
  match '/about'                  => 'pages#about'
  match '/faq'                    => 'pages#faq'
  match '/contact'                => 'pages#contact'
  match '/problem_report'         => 'pages#problem_report'
  match '/terms_of_use'           => 'pages#terms_of_use'
  match '/owner_nomination'  => 'pages#owner_nomination'
  match '/public_nomination' => 'pages#public_nomination'

  # Internal controller
  #match '/internal/feedback', :to => redirect('/internal_feedback.html')
  #Temporarily commenting out these lines below until I can properly integrate the jira submission changes from branch jiraSOAP
  match '/internal/feedback'        => 'internal#feedback_form'
  match '/internal/feedback_submit' => 'internal#feedback_submit'

  # Admin controller
  match '/admin'                    => 'admin#index'
  match '/admin/login_options'      => 'admin#login_options'
  match '/admin/manual_solr_server_override'      => 'admin#manual_solr_server_override'
  # match '/admin/clear_solr_index'   => 'admin#clear_solr_index'
  match '/admin/reindex_solr_from_xml_file'   => 'admin#reindex_solr_from_xml_file'
  match '/admin/update_hardcoded_browse_lists'   => 'admin#update_hardcoded_browse_lists'

  # Api controller
  match '/api'                      => 'api#index'
  match '/api/sites'                => 'api#sites'

  root :to => "catalog#hrwa_home"

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
  # match ':controller(/:action(/:id))(.:format)'
end
