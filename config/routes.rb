Rails.application.routes.draw do
  root to: 'auth#root'

  get 'login' => 'auth#login_page'
  post 'login' => 'auth#login'
  delete 'logout' => 'auth#logout'

  resources :albums, except: [:new, :edit] do
    resources :photos, only: [:show, :create, :update, :destroy], defaults: {anchor: "photo"} do
      resources :comments, only: [:create, :edit, :update, :destroy]
    end

    member do
      get 'add_photo' => 'photos_in_albums#new', as: 'add_photo_to'
      post 'add_photo' => 'photos_in_albums#create', as: nil

      delete 'remove_photo/:photo_id' => 'photos_in_albums#destroy', as: 'remove_photo_from'

      # JSON API
      scope format: false, constraints: lambda { |req| req.format == :json } do
        get 'photo_ids' => 'photos_in_albums#photo_ids'
      end
    end
  end

  resources :users
end
