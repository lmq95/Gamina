# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'homes#top'
  get '/about' => 'homes#about', as: 'about'
  get '/attention' => 'homes#attention', as: 'attention'

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/search' => 'searches#search', as: 'search'

  resources :users, only: %i[index show edit update] do
    resource :relationships, only: %i[create destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end

  resources :posts do
    resources :post_comments, only: %i[create destroy]
    resource :favorites, only: %i[create destroy]
  end

  resources :groups do
    get 'join' => 'groups#join', as: 'join'
  end
  get 'groups/:id/member' => 'groups#member', as: 'member'

  resources :rooms, only: %i[create show]
  resources :messages, only: [:create]

  resources :notifications, only: [:index]

end
