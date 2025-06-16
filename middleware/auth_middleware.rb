require 'jwt'
require_relative '../modules/auth'

class AuthMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    return @app.call(env) if public_path?(request.path)

    auth_header = request.get_header('HTTP_AUTHORIZATION')
    return unauthorized_response unless auth_header

    token = auth_header.split(' ').last
    begin
      decoded = JWT.decode(token, Auth::JWT_SECRET, true, { algorithm: 'HS256' })
      env['user_id'] = decoded[0]['user_id']
      @app.call(env)
    rescue JWT::DecodeError
      unauthorized_response
    end
  end

  private

  def public_path?(path)
    ['/register', '/login', '/openapi.yaml'].include?(path)
  end

  def unauthorized_response
    [401, { 'content-type' => 'application/json' }, [{ error: 'Unauthorized' }.to_json]]
  end
end 