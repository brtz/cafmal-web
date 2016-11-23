class ResourcesController < AuthenticationController
  before_action :set_resource

  def index
    @title = @resource.titleize
    @resources = Oj.load(@cafmal_resource.list)
  end

  def new

  end

  def show
    id = params[:id]
    @cafmal_resource = @cafmal_resource.show(id)
    @resource = Oj.load(@cafmal_resource)
  end

  def create
  end

  private
    def set_resource
      @resource = params[:resource]
      @cafmal_resource = "Cafmal::#{@resource.singularize.capitalize}".constantize.new(Rails.application.secrets.cafmal_api_url, cookies[:cafmal_api_token])
    end
end
