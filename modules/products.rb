require 'securerandom'
require 'json'
require 'redis'
require_relative '../workers/product_worker'

module Products
  module ProductStatus
    PROCESSING = 'processing'
    COMPLETED = 'completed'

    def self.valid?(status)
      [PROCESSING, COMPLETED].include?(status)
    end
  end

  class << self
    def redis
      @redis ||= Redis.new(url: ENV['REDIS_URL'] || 'redis://localhost:6379/0')
    end

    def create(user_id, name)
      product_id = SecureRandom.uuid

      # Enqueue async processing
      ProductWorker.perform_async(product_id, name)

      { status: 200, body: { id: product_id, status: ProductStatus::PROCESSING } }
    end

    def list
      products = redis.keys('product:*').map do |key|
        JSON.parse(redis.get(key), symbolize_names: true)
      end
      { status: 200, body: products }
    end

    def get(id)
      product = redis.get("product:#{id}")
      return { status: 404, body: { error: 'Product not found' } } unless product

      product = JSON.parse(product, symbolize_names: true)
      { status: 200, body: product }
    end

    def complete_processing(product_id)
      if product = redis.get("product:#{product_id}")
        product = JSON.parse(product, symbolize_names: true)
        product[:status] = ProductStatus::COMPLETED
        redis.set("product:#{product_id}", product.to_json)
      end
    end
  end
end 