class BackendController < AuthenticationController
  def dashboard
    @title = "Dashboard"

    # @resource = "events"
    # @cafmal_resource = "Cafmal::#{@resource.singularize.capitalize}".constantize.new(Rails.application.secrets.cafmal_api_url, cookies[:cafmal_api_token])
    # @events = Oj.load(@cafmal_resource.list(86400, 86400))
    # @events = @events.stable_sort_by { |hsh| hsh[:id] }.reverse
    #
    # split_events = []
    #
    # out = {}
    # @events.each do |a_hash|
    #   out[a_hash["name"]] ||= []
    #   out[a_hash["name"]] << a_hash
    # end
    #
    # @split_events_label = []
    #
    # background_colors = ["#F44336", "#E91E63", "#9C27B0", "#673AB7", "#3F51B5", "#2196F3", "#4CAF50", "#FF9800", "#FFEB3B", "#76FF03"]
    #
    # out.keys.each do |key|
    #   data = []
    #   data_out = out[key]
    #   data_out.each do |da|
    #     @split_events_label << da["created_at"].to_datetime.strftime("%Y.%m.%d %H:%M")
    #     data << da["created_at"].to_datetime.to_i
    #   end
    #   split_events << {label: key, data: data, backgroundColor: background_colors.sample}
    # end
    #
    # @split_events = Oj.dump(split_events)
  end
end
