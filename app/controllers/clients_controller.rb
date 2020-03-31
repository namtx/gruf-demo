# frozen_string_literal: true

class ClientsController < ApplicationController
  def index
    search = params[:search]
    begin
      client = ::Gruf::Client.new(service: Rpc::Products)
      response = client.call(:GetProducts, search: search) # This will output the ::Demo::GetJobResp object

      # Basically, the response is enumerator, we should implement Rpc::ProductResponseEnumerator to get products
      response.message.each do |m|
        puts m.inspect
      end
    rescue Gruf::Client::Error => e
      puts e.error.inspect # If an error occurs, this will be the underlying error object
    end
  end

  def show
    id = params[:id].to_i.presence || 1
    begin
      client = ::Gruf::Client.new(service: Rpc::Products)
      response = client.call(:GetProduct, id: id) # This will output the ::Demo::GetJobResp object

      product = response.message.product

      render json: { product: { name: product.name, price: product.price } }
    rescue Gruf::Client::Error => e
      puts e.error.inspect # If an error occurs, this will be the underlying error object
    end
  end

  def create
    client = ::Gruf::Client.new(service: Rpc::Products)
    product = Rpc::Product.new(name: create_params[:name], price: create_params[:price])
    response = client.call(:CreateProducts, [product])

    puts response.message
  rescue Gruf::Client::Error => e
    puts e.error.inspect # If an error occurs, this will be the underlying error object
  end

  private

  def create_params
    params.require(:client).permit(:name, :price)
  end
end
