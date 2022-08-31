json.array!(@master_features) do |feature|
  json.extract! feature, :id, :name
  json.url feature_url(feature, format: :json)
end
