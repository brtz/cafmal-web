class ResourcesController < AuthenticationController
  before_action :set_resource

  def index
    @title = @resource.titleize
    @resources = Oj.load(@cafmal_resource.list)
  end

  def new
    @title = "New #{@resource.singularize.titleize}"
  end

  def edit
    @title = "Edit #{@resource.singularize.titleize}"
    id = params[:id]
    @cafmal_resource = @cafmal_resource.show(id)
    @resource_json = Oj.load(@cafmal_resource)
  end

  def update
    @title = "Update #{@resource.singularize.titleize}"
    resource_params = params_validate
    save = @cafmal_resource.update(resource_params)
    @json_errors = JSON.parse(save)
    if @json_errors.key?("exception")
      exception = @json_errors["exception"]
      @json_errors = {"error" => [exception.to_s]}
    end
    if @json_errors.blank? || @json_errors.class != "String"
      flash[:success] = "#{@resource.singularize.titleize} successfully updated."
      redirect_to resources_index_path(@resource)
    else
      redirect_to resources_edit_path(@resource, resource_params["id"])
    end
  end

  def show
    id = params[:id]
    @cafmal_resource = @cafmal_resource.show(id)
    @resource_json = Oj.load(@cafmal_resource)
  end

  def create
    @title = "Create #{@resource.singularize.titleize}"
    resource_params = params_validate
    save = @cafmal_resource.create(resource_params)
    @json_errors = JSON.parse(save)
    if @json_errors.key?("exception")
      exception = @json_errors["exception"]
      @json_errors = {"error" => [exception.to_s]}
    end
    if @json_errors.blank?
      flash[:success] = "#{@resource.singularize.titleize} successfully created."
      redirect_to resources_index_path(@resource)
    else
      render action: :new
    end
  end

  private
    def set_resource
      @resource_json = nil
      @resource = params[:resource]
      @cafmal_resource = "Cafmal::#{@resource.singularize.capitalize}".constantize.new(Rails.application.secrets.cafmal_api_url, cookies[:cafmal_api_token])
      @form_structure = JSON.parse(@cafmal_resource.new)
    end

    def params_validate
      params.require(@resource.to_sym).permit((@form_structure.keys << :id))
    end
end
