AuthorNames::Application.routes.draw do
  resources :publications


  resources :authors

  resources :responses do
    collection do
      get 'author_response'
      get 'export'
      get 'export_single'
      get 'mark_exported'
      get 'delete_group'
    end
  end  


  resources :questionnaires do
    collection do
      get 'gather_response'
      get 'send_questionnaire'
      get 'choose_authors'
      get 'sort_items'
    end
  end  


  resources :form_items do
    member do
      get 'view_field'
    end
    collection do
      get 'batch_upload'
      post 'import'
    end
  end  

  resources :libraries


  resources :publishers


  devise_for :users
  
  resources :users do
    collection do
      get 'authors'
      get 'bulk_users'
      get 'make_staff'
    end
  end
  
  resources :welcome do
    collection do
      get 'author_home'
    end
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
  root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
