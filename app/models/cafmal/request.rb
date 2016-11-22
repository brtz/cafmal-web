class Cafmal::Request
  require 'httparty'

  @@base_uri = Rails.application.secrets.cafmal_api_url

  attr_accessor :response, :token

  @token = nil
  @response = nil

  def initialize(resource = "user_token", token = nil, params = {})
    @params = params
    @resource = resource
    @headers = {
      'Content-Type': 'application/json'
    }
    unless token.nil?
      @token = token
    end
  end

  def auth
    response = HTTParty.post(@@base_uri + "/#{@resource}", query: @params, headers: @headers)
    if response.code < 300
      @response = response.parsed_response
      set_token
    end
  end

  def call(method = "get")
    @headers['Authorization'] = "Bearer #{@token}"
    response = HTTParty.send(method, @@base_uri + "/#{@resource}", query: @params, headers: @headers)
    if response.code < 300
      @response = response.parsed_response
    end
  end

  def expired?
    (@response.code == 404)
  end

  private

    def set_token
      @token = @response["jwt"] unless @response["jwt"].nil?
    end
end
