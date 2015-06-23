Cms::Engine.routes.draw do

  resources :content_nodes, except: [:new] do
    collection do
      get 'new/:type' => 'content_nodes#new', as: :new
      get ':parent_id/new/:type' => 'content_nodes#new', as: :new_parent
    end
    member do
      post :sort
      get :children
    end
  end

  resources :content_categories

  resources :content_images do
    collection do
      get :search
    end
  end

  resources :content_documents do
    collection do
      get :search
    end
  end

  get 'unauthorized' => 'pages#unauthorized', as: :unauthorized

end
