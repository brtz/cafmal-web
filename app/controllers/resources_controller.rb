class ResourcesController < AuthenticationController
  before_action :set_resource

  def all
    @title = @resource.titleize
    @cafmal_resource = "Cafmal::#{@resource.singularize.capitalize}".constantize.new(Rails.application.secrets.cafmal_api_url, cookies[:cafmal_api_token])
    @resources = Oj.load(@cafmal_resource.list)
  end

  def show
    id = params[:id]
    @cafmal_request = Cafmal::Request.new("#{@resource}/" + id, current_user.token, {})
    @cafmal_request.call
    @resources = @cafmal_request.response
  end

  def create
    @cafmal_request = Cafmal::Request.new(@resource, current_user.token, {})
    @cafmal_request.call
  end

  private
    def set_resource
      @resource = params[:resource]
    end
end
