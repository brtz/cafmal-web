class User
  attr_accessor :token, :id, :exp, :role, :firstname, :lastname, :team_id, :email

  @token = nil
  @id = nil
  @exp = 0
  @role = nil
  @firstname = nil
  @lastname = nil
  @team_id = nil
  @email = nil

  def initialize(token)
    @token = token

    unless @token.blank?
      decoded_token = JSON.parse(Base64.decode64(@token.split(".").second))
      @id = decoded_token["sub"]
      @exp = decoded_token["exp"]
      @role = decoded_token["role"]
      @firstname = decoded_token["firstname"]
      @lastname = decoded_token["lastname"]
      @team_id = decoded_token["team_id"]
      @email = decoded_token["email"]
    end
  end

  def admin?
    @role == "admin"
  end

  def minutes_til_expiration
    expired_at = Time.at(@exp.to_i).utc
    ((expired_at - Time.now.utc) / 60).to_i
  end

  def expired?
    expired_at = Time.at(@exp.to_i).utc.to_datetime
    expired_at.past?
  end

  def signed_in?
    !@token.blank? && !self.expired?
  end
end
