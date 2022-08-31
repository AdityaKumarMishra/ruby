json.array!(@product_versions) do |product_version|
  json.extract! product_version, :id, :name, :price, :type
  json.url product_version_url(product_version, format: :json)
end
