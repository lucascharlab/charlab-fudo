require 'sidekiq'
require 'json'
require_relative '../modules/products'

class ProductWorker
  include Sidekiq::Worker

  def perform(product_id, name)
    # Create the product in Redis
    product = {
      id: product_id,
      name: name,
      status: Products::ProductStatus::PROCESSING
    }
    Products.redis.set("product:#{product_id}", product.to_json)
    
    # Simulate work
    sleep 5
    
    # Update product status
    Products.complete_processing(product_id)
  end
end 