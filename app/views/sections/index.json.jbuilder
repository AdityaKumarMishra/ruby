json.array!(@sections) do |section|
  json.extract! section, :id, :title, :duration, :position, :sectionable_id, :sectionable_type
  json.url section_url(section, format: :json)
end
