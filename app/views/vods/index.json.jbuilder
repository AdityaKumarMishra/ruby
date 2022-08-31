json.array!(@vods) do |vod|
  json.extract! vod, :id, :title, :date_published, :published, :viewcount, :video
  json.url vod_url(vod, format: :json)
end
