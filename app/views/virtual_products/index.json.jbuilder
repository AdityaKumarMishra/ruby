json.array!(@@virtual_products) do |product|
  json.extract! product, :id, :sku, :currency, :name, :description, :cost, :type, :weight, :length, :width, :height, :starting_date, :stopping_date, :expiration_date, :course_version_id
  json.url product_url(product, format: :json)
end
