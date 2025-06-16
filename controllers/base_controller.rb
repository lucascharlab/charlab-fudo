require 'json'
require 'logger'

class BaseController
  def initialize(request)
    @request = request
    @logger = Logger.new(STDOUT)
  end

  protected

  def json_response(status, body)
    [status, { 'content-type' => 'application/json' }, [body.to_json]]
  end

  def parse_json_body
    JSON.parse(@request.body.read)
  rescue JSON::ParserError
    nil
  end

  def user_id
    @request.env['user_id']
  end

  def logger
    @logger
  end

  def log_debug(message)
    STDERR.puts "DEBUG: #{message}"
  end
end 