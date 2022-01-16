# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'welcome#index'

  get '/dashboard', to: 'dashboard#index', as: 'dashboard'

  scope :dashboard do
    # Devise stuff
    devise_for :users, skip: %i[registrations],
                       controllers: { sessions: 'users/sessions',
                                      passwords: 'users/passwords',
                                      invitations: 'users/invitations' }
    as :user do
      get 'users/edit', to: 'devise/registrations#edit', as: 'edit_user_registration'
      put 'users', to: 'devise/registrations#update', as: 'user_registration'
    end

    # General Resources
    resources :universities
    resources :bus_companies
    resources :user_tickets, only: %i[create update destroy]
    resources :tickets

    resources :transactions, except: %i[new create] do
      collection do
        get '/:id/open', to: 'transactions#open', as: 'open'
        get '/:id/finish', to: 'transactions#finish', as: 'finish'
        get '/:id/close', to: 'transactions#close', as: 'close'
      end
    end

    resources :cities do
      collection do
        get '/all', to: 'cities#all', as: 'all'
      end
    end

    # User model routes
    resources :users, except: %i[new create destroy] do
      resources :transactions, only: %i[index create], controller: 'users/transactions'
      post '/reinvite', to: 'users#reinvite', as: 'reinvite'
    end

    # Change direction route
    resource :direction, only: %i[show edit update], controller: 'direction'
  end
end
