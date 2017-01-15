class AuthenticationController < ApplicationController
  before_action :authenticate_user!
  before_action :check_expiration

  def login
    @title = "Login"
  end

  def refresh_login
    @cafmal_auth = Cafmal::Auth.new(Rails.application.secrets.cafmal_api_url)

    if @cafmal_auth.refresh(cookies[:cafmal_api_token])
      flash[:notice] = "Login refreshed."
      set_cafmal_api_token(@cafmal_auth.token)
    else
      flash[:error] = "Login could not be refreshed."
    end
    redirect_back(fallback_location: :back)
  end

  def logout
    @cafmal_auth = Cafmal::Auth.new(Rails.application.secrets.cafmal_api_url)
    @cafmal_auth.logout(cookies[:cafmal_api_token])
    delete_cafmal_api_token
    flash[:notice] = "Farewell!"
    redirect_to login_path
  end

  def auth
    @cafmal_auth = Cafmal::Auth.new(Rails.application.secrets.cafmal_api_url)

    @cafmal_auth.login(user_params[:email], user_params[:password])

    unless @cafmal_auth.token.nil?
      flash[:notice] = "Successfully logged in"
      set_cafmal_api_token(@cafmal_auth.token)
      redirect_to dashboard_path
    else
      flash[:error] = "Wrong credentials."
      redirect_to login_path
    end
  end

  private
    def authenticate_user!
      redirect_to login_path if !current_user.signed_in? && params[:controller] != "authentication"
    end

    def check_expiration
      if current_user.signed_in?
        flash[:error]  = "Less than 15 minutes til logout." if current_user.minutes_til_expiration <= 15
      end
    end

    def user_params
      params.require(:user).permit(:email, :password)
    end
end
