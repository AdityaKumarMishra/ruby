json.array!(@section_items) do |section_item|
  json.extract! section_item, :id, :section_id, :mcq_stem_id, :mcq_id
  json.url section_item_url(section_item, format: :json)
end
