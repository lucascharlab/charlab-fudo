# config.ru
require 'bundler'
Bundler.require

require_relative 'app'
require_relative 'middleware/auth_middleware'
require 'sidekiq/web'
require 'rack'
require 'rack/static'
require_relative 'middleware/error_handler'
require_relative 'middleware/request_logger'

# Serve static files with appropriate caching rules
use Rack::Static, {
  urls: ["/AUTHORS", "/openapi.yaml"],
  root: "public",
  header_rules: [
    [:all, {
      'cache-control' => 'public, max-age=86400'
    }],
    [/^\/openapi\.yaml$/, {
      'cache-control' => 'no-store, no-cache, must-revalidate, max-age=0, private',
      'pragma' => 'no-cache',
      'expires' => '0',
      'surrogate-control' => 'no-store'
    }],
  ]
}

use RequestLogger
use Rack::CommonLogger
use Rack::Deflater

# Mount Sidekiq Web UI with session-based authentication
map '/sidekiq' do
  use Rack::Session::Cookie, 
    secret: File.read('.session.key'),
    same_site: true,
    max_age: 86400
  run Sidekiq::Web
end

use AuthMiddleware
use ErrorHandler
run App.new
