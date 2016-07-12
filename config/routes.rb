Rails.application.routes.draw do
  root to: redirect('albums')
  
  resources :albums
  resources :photos
  resources :photo_in_albums
  resources :comments
  resources :users
end
