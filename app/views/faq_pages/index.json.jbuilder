json.array!(@faq_pages) do |faq_page|
  json.extract! faq_page, :id, :faq_topic_id, :content
  json.url faq_page_url(faq_page, format: :json)
end
