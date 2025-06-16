require 'logger'

class RequestLogger
  def initialize(app)
    @app = app
    @logger = Logger.new(STDOUT)
  end

  def call(env)
    request_started_at = Time.now
    status, headers, response = @app.call(env)
    request_ended_at = Time.now

    log_request(env, status, request_ended_at - request_started_at)
    [status, headers, response]
  end

  private

  def log_request(env, status, duration)
    method = env['REQUEST_METHOD']
    path = env['PATH_INFO']
    query = env['QUERY_STRING']
    user_agent = env['HTTP_USER_AGENT']
    ip = env['REMOTE_ADDR']
    user_id = env['user_id']

    @logger.info(
      "Request: #{method} #{path}#{query.empty? ? '' : "?#{query}"} " \
      "Status: #{status} Duration: #{duration.round(2)}s " \
      "User: #{user_id || 'anonymous'} " \
      "IP: #{ip} " \
      "UA: #{user_agent}"
    )
  end
end 