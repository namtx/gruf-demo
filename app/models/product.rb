class Product < ApplicationRecord
  def to_proto
    Rpc::Product.new(
      id: id.to_i,
      name: name.to_s,
      price: price.to_f
    )
  end

  def as_json(*args)
    {
      id: id.to_i,
      name: name.to_s,
      price: price.to_f
    }
  end
end
