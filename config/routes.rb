# require 'resque_web'

SnippetManager::Application.routes.draw do

  namespace :api do
  get 'search/create'
  end

  namespace :api do
  get 'search/show'
  end

  # display Resque dashboard at /resque
  #@todo
  # not working right now for some
  # mount ResqueWeb::Engine => "/resque_web"


  namespace :api,defaults:{format: :json} do


    root 'base#show'

    resource :search

    resources :snippets, except:[:edit,:new]
    resources :categories,only:[:index,:show] do
      resources :snippets,only:[:index,:show,:create]
    end
    resources :sessions,only:[:create,:destroy]
    resources :users ,only:[:index,:show,:create] do
      resources :snippets,only:[:index,:show,:update,:destroy,:create]
    end
  end


  root 'staticpages#index'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
