require_relative 'base_controller'
require_relative '../modules/products'

class ProductsController < BaseController
  def create
    data = parse_json_body
    return json_response(400, { error: 'Invalid JSON' }) unless data

    response = Products.create(user_id, data['name'])
    json_response(response[:status], response[:body])
  end

  def list
    response = Products.list
    json_response(response[:status], response[:body])
  end

  def get(id)
    response = Products.get(id)
    json_response(response[:status], response[:body])
  end
end 