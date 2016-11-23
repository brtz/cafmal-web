class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_default_page_title
  before_action :authenticate_user!

  def current_user
    User.new(cookies[:cafmal_api_token])
  end

  def set_cafmal_api_token(token)
    cookies[:cafmal_api_token] = {value: token}
  end

  def delete_cafmal_api_token
    cookies.delete :cafmal_api_token
  end

  private

    def set_default_page_title
      @title = "#{params[:controller].titleize} - #{params[:action].titleize}"
    end

    def cafmal_request_expired?
      unless @cafmal_auth.nil?
        @cafmal_auth.expired?
      end
    end

    def authenticate_user!
      if !current_user.signed_in? && params[:controller] != "authentication" && cafmal_request_expired?
        delete_cafmal_api_token
        flash[:alert] = "Your session has expired."
        redirect_to login_path
      end
    end
end
