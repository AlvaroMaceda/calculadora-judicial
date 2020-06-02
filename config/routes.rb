Rails.application.routes.draw do
    # resources :campaigns
    # resources :accounts
    resources :countries

    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
    root 'static#index'

    namespace :admin do
        get '/import/territories', to: 'territory_import#new'
        post '/import/territories', to: 'territory_import#import'
    end

    namespace :api, defaults: {format: 'json'} do
        get 'municipality/search/:name', to: 'municipality_search#search'
        get 'deadline', to: 'deadline_calculator#deadline'
    end
end