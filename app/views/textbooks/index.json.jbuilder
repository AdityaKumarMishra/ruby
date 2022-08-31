json.array!(@textbooks) do |textbook|
  json.extract! textbook, :id, :title, :document
  json.url textbook_url(textbook, format: :json)
end
