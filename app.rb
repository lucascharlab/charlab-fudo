require 'rack'
require_relative 'controllers/auth_controller'
require_relative 'controllers/products_controller'

class App
  def call(env)
    request = Rack::Request.new(env)
    puts "\n=== REQUEST DEBUG ==="
    puts "Method: #{request.request_method}"
    puts "Path: #{request.path}"
    puts "Full env: #{env.inspect}"
    puts "===================\n"
    handle_request(request)
  end

  private

  def handle_request(request)
    path = request.path
    method = request.request_method

    puts "\n=== ROUTING DEBUG ==="
    puts "Handling request - Method: #{method}, Path: #{path}"
    puts "Case comparison: [#{method}, #{path}]"

    case [method, path]
    when ['POST', '/register']
      puts "Matched register route"
      AuthController.new(request).register
    when ['POST', '/login']
      puts "Matched login route"
      AuthController.new(request).login
    when ['POST', '/products']
      ProductsController.new(request).create
    when ['GET', '/products']
      ProductsController.new(request).list
    when ['GET', path]
      if path =~ %r{^/products/([^/]+)$}
        ProductsController.new(request).get($1)
      else
        [404, { 'content-type' => 'application/json' }, [{ error: 'Not found' }.to_json]]
      end
    else
      puts "No matching route for: #{method} #{path}"
      [404, { 'content-type' => 'application/json' }, [{ error: 'Not found' }.to_json]]
    end
  end
end