class AuthenticationController < ApplicationController
  def login
    @title = "Login"
  end

  def logout
    delete_cafmal_api_token
    flash[:notice] = "Farewell!"
    redirect_to login_path
  end

  def auth
    @cafmal_request = Cafmal::Request.new("user_token", nil, {"auth": {"email": user_params[:email], "password": user_params[:password]}})
    @cafmal_request.auth
    unless @cafmal_request.token.nil?
      flash[:notice] = "Successfully logged in"
      set_cafmal_api_token(@cafmal_request.token)
      @cafmal_request = Cafmal::Request.new("users/#{current_user.id}", current_user.token, {})
      @cafmal_request.call
      @resources = @cafmal_request.response

      @cafmal_request = Cafmal::Request.new("events", current_user.token, {event: {name: "user_login", kind: 'login', message: "#{@resources["email"]} has logged in", severity: "info", team_id: @resources["team_id"]} })
      @cafmal_request.call("post")
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
