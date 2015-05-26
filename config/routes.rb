Cms::Engine.routes.draw do
  # devise_for :users, class_name: "Cms::User", module: :devise

  resources :content_nodes, except: [:new] do
    collection do
      get 'new/:type' => 'content_nodes#new', as: :new
      get ':parent_id/new/:type' => 'content_nodes#new', as: :new_parent
    end
    member do
      post :up
      post :down
      get :version
      get :versions
      get :children
      post 'set_version' => 'content_nodes#set_current_version', :as => :set_version
    end
  end

  resources :content_categories

  resources :content_images do
    collection do
      get :search
    end
  end

end
