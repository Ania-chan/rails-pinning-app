Rails.application.routes.draw do
  resources :followers
  resources :boards
  resources :users, except: [:index]
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'pins#index'

  get "pins/name-:slug" => "pins#show_by_name", as: "pin_by_name"

  get "pins/name-:slug/edit" => "pins#edit_by_name", as: "pin_edit_by_name"
  
  resources :pins

  get '/library' => 'pins#index'

  get 'signup' => "users#new", as: :signup

  get 'login' => "users#login", as: :login

  post 'login' => "users#authenticate"

  delete 'logout/:id' => "users#logout", as: :logout

  post "pins/repin/:id" => "pins#repin", as: 'repin'

  get "boards/name-:nam" => "boards#show_board_by_name", as: "board_by_name"
    
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
