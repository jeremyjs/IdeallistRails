json.array!(@products) do |product|
  json.extract! product, :id, :isbn, :title, :author, :publisher, :price, :category_id, :amazon_url, :small_image_url, :medium_image_url
  json.url product_url(product, format: :json)
end
