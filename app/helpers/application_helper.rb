module ApplicationHelper
  def current_user
    User.new(cookies[:cafmal_api_token])
  end

  def bootstrap_class_for flash_type
      { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type.to_sym] || flash_type.to_s
  end

  def try_to_convert_to_date(string)
    begin
      return string.to_datetime.strftime("%d.%m.%Y %H:%M:%S")
    rescue Exception => e
      return string
    end
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
