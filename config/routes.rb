Rails.application.routes.draw do
  resources :carts
  #get 'homes/show'

  resources :contacts
  resources :packages
  resources :blogs
  resources :newsletters
  resources :testimonials

  get "homes/show"
  get 'welcome/index'
  get 'welcome/get_products'
  get 'welcome/show'
  get '/store' => 'welcome#store'
  get '/store_details' => 'welcome#store_details'
  get '/item_lookup' => 'welcome#item_lookup'
  get '/blog' => 'welcome#blog' 
  get '/blog_detail' => 'welcome#blog_detail'
  post '/cart_creation' => 'welcome#cart_creation'
  get '/cart_addition' => 'welcome#cart_addition'
  get '/cart_get' => 'welcome#cart_get'
  get '/cart_remove' => 'welcome#cart_remove'
  get 'welcome/store_details'
  get '/blog_list' => 'welcome#blog' 
  #get '/blog_detail' => 'welcome#blog_detail'
  get 'welcome/blog_details'
  get '/about' => 'welcome#about'
  get '/contact' => 'welcome#contact'
  get '/package' => 'welcome#package'
  post 'welcome/add_comment'
  post 'welcome/add_newsletter'
  post 'contacts/add_newsletter'
  post 'packages/add_newsletter'


  # scope '/admin' do
    devise_for :users, :controllers => {:sessions => "sessions", :registrations => "registrations"}
  # end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  namespace :admin do
    root "users#index"
    resources :contacts
    resources :blogs
    resources :categories
    resources :packages
    resources :newsletters
    resources :testimonials
  end


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
