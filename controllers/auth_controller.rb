require_relative 'base_controller'
require_relative '../modules/auth'

class AuthController < BaseController
  def register
    puts "\n=== REGISTER DEBUG ==="
    puts "Request method: #{@request.request_method}"
    puts "Request path: #{@request.path}"
    puts "Request body: #{@request.body.read}"
    @request.body.rewind  # Reset the body position after reading
    puts "===================\n"

    data = parse_json_body
    return json_response(400, { error: 'Invalid JSON' }) unless data

    response = Auth.register(data['email'], data['password'])
    json_response(response[:status], response[:body])
  end

  def login
    puts "\n=== LOGIN DEBUG ==="
    puts "Request method: #{@request.request_method}"
    puts "Request path: #{@request.path}"
    puts "Request body: #{@request.body.read}"
    @request.body.rewind  # Reset the body position after reading
    puts "===================\n"

    data = parse_json_body
    return json_response(400, { error: 'Invalid JSON' }) unless data

    response = Auth.login(data['email'], data['password'])
    json_response(response[:status], response[:body])
  end

  private

  def method_not_allowed
    json_response(405, { error: 'Method not allowed' })
  end
end 