json.array!(@tags) do |tag|
  json.extract! tag, :id, :name, :description, :tagging_count, :parent_id
  json.url tag_url(tag, format: :json)
  json.children children_for_tag_tag_search_url id: tag.id
  json.answerers answerer_for_tag_tag_search_url id: tag.id
end
