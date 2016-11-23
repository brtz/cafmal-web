Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope :authentication do
    get 'login', to: 'authentication#login', as: :login
    delete 'logout', to: 'authentication#logout', as: :logout
    post 'auth', to: 'authentication#auth', as: :auth
  end

  scope :settings do
    get '/', to: 'settings#index', as: :settings
  end

  namespace :resources, path: "/" do
    scope ":resource" do
      get '/', action: :index, as: :index
      get '/:id', action: :show, as: :show
      get '/:id/edit', action: :edit, as: :edit
      get '/new', action: :edit, as: :new
      post '/create', action: :create, as: :create
    end
  end

  root to: 'backend#dashboard', as: :dashboard
end
