json.array!(@exam_sections) do |exam_section|
  json.extract! exam_section, :id, :title, :dificultyRating, :exam_id
  json.url exam_section_url(exam_section, format: :json)
end
