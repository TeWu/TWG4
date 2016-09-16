Rails.application.routes.draw do
  json_only = {constraints: lambda { |req| req.format == :json }}

  root to: 'auth#root'

  get 'login' => 'auth#login_page'
  post 'login' => 'auth#login'
  delete 'logout' => 'auth#logout'

  resources :albums, except: [:new, :edit] do
    resources :photos, only: :show, defaults: {anchor: "photo"}
    resources :photos, only: :update, **json_only
    resources :photos, only: [:create, :destroy] do
      resources :comments, only: [:create, :edit, :update, :destroy]
      get 'comments' => redirect('/albums/%{album_id}/photos/%{id}#comments-section'), on: :member
    end

    member do
      get 'photos' => redirect('/albums/%{id}')
      delete 'remove-photo/:photo_id' => 'photos_in_albums#destroy', as: 'remove_photo_from'
      scope json_only do
        post 'add-photo' => 'photos_in_albums#create', as: 'add_photo_to'
        get 'photo-ids' => 'photos_in_albums#photo_ids'
      end
    end
  end

  resources :users, except: [:new, :edit]
end
