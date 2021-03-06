class ResourcesController < AuthenticationController
  before_action :set_resource

  def index
    @title = @resource.titleize
    query ||= params["query"]
    @query_duration =  (query.blank? ? 3600 : query["duration"])
    @query_age = (query.blank? ? 3600 : query["age"])
    @show_deleted_resources = (query.blank? ? false : (query["show_deleted_resources"] == "1"))
    if @resource == "events"
      @resources = Oj.load(@cafmal_resource.list(@query_age, @query_duration).body)
      @resources = @resources.stable_sort_by { |hsh| hsh[:id] }.reverse
    else
      @resources = Oj.load(@cafmal_resource.list.body)
    end
    if !@show_deleted_resources
      @resources.delete_if{|i|!i["deleted_at"].blank?}
    end

    if @resource == "events"
      @search_options = {
        form_obj: :query, show_deleted_resources: true,
        fields: {
          age: {
            value: @query_age, type: :integer
          },
          duration: {
            value: @query_duration, type: :integer
          }
        }
      }
    else
        @search_options = {form_obj: :query, show_deleted_resources: true}
    end
  end

  def new
    @title = "New #{@resource.singularize.titleize}"
  end

  def edit
    @title = "Edit #{@resource.singularize.titleize}"
    id = params[:id]
    @cafmal_resource = @cafmal_resource.show(id)
    @resource_json = Oj.load(@cafmal_resource.body)
  end

  def update
    @title = "Update #{@resource.singularize.titleize}"
    resource_params = params_validate
    save = @cafmal_resource.update(resource_params)
    @json_errors = handle_error_messages(save)
    if save.response.code.to_i < 300
      flash[:success] = "#{@resource.singularize.titleize} successfully updated."
      redirect_to resources_index_path(@resource)
    else
      render :edit
    end
  end

  def create
    @title = "Create #{@resource.singularize.titleize}"
    resource_params = params_validate
    save = @cafmal_resource.create(resource_params)
    @json_errors = handle_error_messages(save)
    if save.response.code.to_i < 300
      flash[:success] = "#{@resource.singularize.titleize} successfully created."
      redirect_to resources_index_path(@resource)
    else
      render action: :new
    end
  end

  def destroy
    @title = "Destroy #{@resource.singularize.titleize}"
    resource_params = params_validate
    save = @cafmal_resource.destroy(resource_params)
    @json_errors = handle_error_messages(save)
    if save.response.code.to_i < 300
      flash[:success] = "#{@resource.singularize.titleize} successfully destroyed."
      redirect_to resources_index_path(@resource)
    else
      render action: :new
    end
  end

  def show
    id = params[:id]
    @cafmal_resource = @cafmal_resource.show(id)
    @resource_json = Oj.load(@cafmal_resource.body)
  end

  def confirm_destroy
    @title = "Confirm destruction of #{@resource.singularize.titleize}"
    id = params[:id]
    @cafmal_resource = @cafmal_resource.show(id)
    @resource_json = Oj.load(@cafmal_resource.body)
  end


  private
    def handle_error_messages(save_result)
      json_errors = JSON.parse(save_result.body)
      unless json_errors.nil?
        if json_errors.key?("exception")
          exception = json_errors["exception"]
          json_errors = {"error" => [exception.to_s]}
        elsif json_errors.key?("message")
          json_errors = {message: [json_errors["message"]]}
        end
      end
      json_errors
    end

    def set_resource
      @resource_json = nil
      @resource = params[:resource]
      @cafmal_resource = "Cafmal::#{@resource.singularize.capitalize}".constantize.new(Rails.application.secrets.cafmal_api_url, cookies[:cafmal_api_token])
      new_cafmal_resouce = @cafmal_resource.new
      @form_structure = JSON.parse(new_cafmal_resouce.body)
    end

    def params_validate
      params.require(@resource.to_sym).permit((@form_structure.keys << :id))
    end

    def render(*args)
      template_name = "/#{@resource}/#{action_name}"
      options = args.extract_options!
      if template_exists?(action_name, @resource)
        options[:template] = template_name if action_name == "index"
      end
      super(*(args << options))
    end
end
