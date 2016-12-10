class BackendController < AuthenticationController
  def dashboard
    require 'digest/md5'

    @title = "Dashboard"

    @resource = "events"
    @cafmal_resource = "Cafmal::#{@resource.singularize.capitalize}".constantize.new(Rails.application.secrets.cafmal_api_url, cookies[:cafmal_api_token])
    @events = Oj.load(@cafmal_resource.list(3600, 3600))
    @events = @events.stable_sort_by { |hsh| hsh[:id] }

    event_labels = []

    @events.each do |event_hash|
      event_labels << event_hash["name"]
    end

    event_labels.uniq!

    datasets = []

    event_labels.each do |event_label|
      data = []
      i = 5
      j = 1
      color_as_number = (Digest::MD5.hexdigest(event_label).to_i(16))
      opacity = 1.00 - ((1.00 / color_as_number.to_s[0..2].to_i) * 100.00)
      bgcolor = ""
      @events.each do |event_hash|
        if event_hash["name"] == event_label
          data << {x: (event_hash["created_at"].to_datetime.to_i - DateTime.now.utc.to_i) / 60, y: j, r: i}

          case event_hash["severity"]
          when "info"
            bgcolor = "rgba(63, 81, 181, #{opacity})"
          when "warning"
            bgcolor = "rgba(255, 235, 59, #{opacity})"
          when "critical"
            bgcolor = "rgba(244, 67, 54, #{opacity})"
          when "error"
            bgcolor = "rgba(0,0,0, #{opacity})"
          end
          i += 0.75
          j += 1
        end
      end
      datasets << { label: event_label, data: data, backgroundColor: bgcolor }

    end

    events_data = { datasets: datasets }

    @events_data  = Oj.dump(events_data)
  end
end
