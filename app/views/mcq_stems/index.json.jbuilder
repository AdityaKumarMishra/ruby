json.array!(@mcq_stems) do |mcq_stem|
  json.extract! mcq_stem, :id, :title, :description
  json.url mcq_stem_url(mcq_stem, format: :json)
end
