require_relative 'base_controller'
require_relative '../modules/products'

class ProductsController < BaseController
  def create
    data = parse_json_body
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