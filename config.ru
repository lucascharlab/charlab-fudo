# config.ru
require 'bundler'
Bundler.require

require_relative 'app'
require_relative 'middleware/auth_middleware'
require 'sidekiq/web'

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
run App.new
