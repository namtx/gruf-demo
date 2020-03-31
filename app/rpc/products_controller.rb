require_relative './app/proto/Products_pb.rb'
require_relative './app/proto/Products_services_pb'


class ProductsController < Gruf::Controllers::Base
  bind ::Rpc::Products::Service

  def initialize(*args)
    @received_products = Hash.new { |h, k| h[k] = [] }
    super
  end

  def get_product
    product = Product.find(request.message.id.to_i)

    Rpc::GetProductResp.new(
      product: Rpc::Product.new(
        id: product.id,
        name: product.name,
        price: product.price
      )
    )
  rescue
    fail!(:not_found, :product_not_found, "Failed to find Product with ID: #{request.message.id}")
  end

  def get_products
    q = Product

    q = q.where('name LIKE ?', "#{request.message.search}%") if request.message.search.present?
    limit = request.message.limit.to_i > 0 ? request.message.limit : 10

    products = q.limit(limit).all
    products.map(&:to_proto)
  rescue => e
    fail!(:internal, :unknown, "Unknow error when listing Product: #{e.message}")
  end

  def create_products
    products = []
    request.messages do |message|
      products << Product.create(name: message.name, price: message.price).to_proto
    end

    Rpc::CreateProductsResp.new(products: products)
  end

  def create_product_in_stream
    products = []
    request.messages.each do |r|
      products << Product.new(name: r.name, price: r.price).to_proto
    end

    products
  end
end
