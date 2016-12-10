class BackendController < AuthenticationController
  def dashboard
    @title = "Dashboard"

    @resource = "events"
    @cafmal_resource = "Cafmal::#{@resource.singularize.capitalize}".constantize.new(Rails.application.secrets.cafmal_api_url, cookies[:cafmal_api_token])
    @events = Oj.load(@cafmal_resource.list(86400, 86400))
    @events = @events.stable_sort_by { |hsh| hsh[:id] }.reverse

    split_events = []

    out = {}
    @events.each do |a_hash|
      out[a_hash["name"]] ||= []
      out[a_hash["name"]] << a_hash
    end

    @split_events_label = []

    background_colors = ["#F44336", "#E91E63", "#9C27B0", "#673AB7", "#3F51B5", "#2196F3", "#4CAF50", "#FF9800", "#FFEB3B", "#76FF03"]
    data_labels = {}

    new_data = {}

    error_types = []

    background_colors = []

    out.keys.each do |key|
      new_data[key] ||= Hash.new(0)
      data_out = out[key]

      severity_names = {}
      data_out.each do |da|
        severity_names[da["severity"]] ||= 0
        severity_names[da["severity"]] += 1
        error_types << da["severity"]
      end
      new_data[key] = severity_names
    end

    error_types = error_types.uniq
    error_types.each do |a|
      @split_events_label << a
      if a == "critical"
        background_colors << "red"
      elsif a == "warning"
        background_colors << "yellow"
      elsif a == "info"
        background_colors << "gray"
      elsif a == "error"
        background_colors << "black"
      end
    end

    new_data.each do |sn|
      data = []
      error_types.each do |err_type|
        data << sn.last[err_type].to_i
      end

      split_events << {label: sn.first, data: data, backgroundColor: background_colors}
    end

    @split_events = Oj.dump(split_events)

    # out.keys.each do |key|
    #   data = []
    #
    #   data_out = out[key]
    #   i = 0
    #   data_out.each do |da|
    #     #data_labels[da["created_at"].to_datetime.strftime("%Y.%m.%d %H")] = ""
    #     i += 1
    #     data << da
    #     #data << 1 #da["created_at"].to_datetime.to_i
    #   end
    #
    #   split_events << {label: key, data: data, backgroundColor: background_colors.sample}
    # end
    # @split_events_label = data_labels.keys
    #
    # @split_events = Oj.dump(split_events)
  end
end
