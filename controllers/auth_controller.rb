require_relative 'base_controller'
require_relative '../modules/auth'

class AuthController < BaseController
  def register
    data = parse_json_body
    response = Auth.register(data['email'], data['password'])
    json_response(response[:status], response[:body])
  end

  def login
    data = parse_json_body
    response = Auth.login(data['email'], data['password'])
    json_response(response[:status], response[:body])
  end

  private

  def method_not_allowed
    raise MethodNotAllowedError
  end
end 