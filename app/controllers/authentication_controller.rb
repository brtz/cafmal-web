class AuthenticationController < ApplicationController
  def login
    @title = "Login"
  end

  def logout
    delete_cafmal_api_token
    #@cafmal_auth.logout
    flash[:notice] = "Farewell!"
    redirect_to login_path
  end

  def auth
    @cafmal_auth = Cafmal::Auth.new(Rails.application.secrets.cafmal_api_url)
    @cafmal_auth.login( user_params[:email], user_params[:password] )

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
    def user_params
      params.require(:user).permit(:email, :password)
    end
end
