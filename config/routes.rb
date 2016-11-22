Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope :authentication do
    get 'login', to: 'authentication#login', as: :login
    delete 'logout', to: 'authentication#logout', as: :logout
    post 'auth', to: 'authentication#auth', as: :auth
  end

  namespace :resources, path: "/" do
    scope ":resource" do
      get '/', action: :all, as: :all
      get '/:id', action: :show, as: :show
    end
  end

  root to: 'backend#dashboard', as: :dashboard
end
