module ApplicationHelper
  def current_user
    User.new(cookies[:cafmal_api_token])
  end

  def bootstrap_class_for flash_type
      { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type.to_sym] || flash_type.to_s
  end

  def try_to_conver_resouce(key = "", string = "")
    return_val = string
    if key.include?("_at") || key.include?("since")
      begin
        return_val = string.to_datetime.strftime("%d.%m.%Y %H:%M:%S")
      rescue Exception => e
      end
    elsif key.include?("is_")
      return_val = (string == false ? "No" : "Yes")
    elsif string.blank?
      return_val = "-"
    end

    return return_val
  end

  def night_theme?
    start   = Time.now.strftime("%H").to_i
    if start >= 18 || start < 8
      return 'dark-theme'
    else
      return ''
    end
  end
end
