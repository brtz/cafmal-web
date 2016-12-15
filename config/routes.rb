Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope :authentication do
    get 'login', to: 'authentication#login', as: :login
    delete 'logout', to: 'authentication#logout', as: :logout
    post 'auth', to: 'authentication#auth', as: :auth
    get 'refresh_login', to: 'authentication#refresh_login', as: :refresh_login
  end

  scope :settings, controller: :settings do
    get '/', action: :index, as: :settings
  end

  scope :sites, controller: :sites do
    get 'about', as: :about
  end

  namespace :resources, path: "/" do
    scope ":resource" do
      get '/', action: :index, as: :index
      get '/new', action: :new, as: :new
      post '/create', action: :create, as: :create
      post '/update', action: :update, as: :update
      post '/destroy', action: :destroy, as: :destroy
      get '/:id', action: :show, as: :show
      get '/:id/edit', action: :edit, as: :edit
      get '/:id/confirm_destroy', action: :confirm_destroy, as: :confirm_destroy
    end
  end
  root to: 'backend#dashboard', as: :dashboard
end
