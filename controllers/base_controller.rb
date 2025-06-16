require 'json'
require_relative '../errors/application_error'

class BaseController
  def initialize(request)
    @request = request
  end

  protected

  def json_response(status, body)
    [status, { 'content-type' => 'application/json' }, [body.to_json]]
  end

  def parse_json_body
    JSON.parse(@request.body.read)
  rescue JSON::ParserError => e
    raise BadRequestError, 'Invalid JSON'
  end

  def user_id
    @request.env['user_id']
  end
end 