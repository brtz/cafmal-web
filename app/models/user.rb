class User
  attr_accessor :token, :id, :exp, :role

  @token = nil
  @id = nil
  @exp = 0
  @role = nil

  def initialize(token)
    @token = token

    unless @token.blank?
      decoded_token = JSON.parse(Base64.decode64(@token.split(".").second))
      @id = decoded_token["sub"]
      @exp = decoded_token["exp"]
      @role = decoded_token["role"]
    end
  end

  def admin?
    @role == "admin"
  end

  def expired?
    expired_at = Time.at(@exp.to_i).utc.to_datetime
    expired_at.past?
  end

  def signed_in?
    !@token.blank? && !self.expired?
  end
end
