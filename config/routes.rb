Rails.application.routes.draw do
  root to: redirect('albums')

  resources :albums, except: :new do
    resources :photos, except: :index do
      resources :comments, only: [:create, :edit, :update, :destroy]
    end

    member do
      get 'add_photo' => 'photos_in_albums#new', as: 'add_photo_to'
      post 'add_photo' => 'photos_in_albums#create', as: nil

      delete 'remove_photo/:id' => 'photos_in_albums#destroy', as: 'remove_photo_from'
    end
  end

  resources :users
end
