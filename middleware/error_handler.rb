require 'logger'

class ErrorHandler
  def initialize(app)
    @app = app
    @logger = Logger.new(STDOUT)
  end

  def call(env)
    @app.call(env)
  rescue StandardError => e
    log_error(e)
    error_response(e)
  end

  private

  def log_error(error)
    @logger.error "Error: #{error.class} - #{error.message}"
    @logger.error error.backtrace.join("\n")
  end

  def error_response(error)
    status = error.respond_to?(:status) ? error.status : 500
    body = {
      error: error.respond_to?(:message) ? error.message : 'Internal Server Error'
    }

    [status, { 'content-type' => 'application/json' }, [body.to_json]]
  end
end 