json.array!(@tickets) do |ticket|
  json.extract! ticket, :id, :title, :question, :asker_id, :answerer_id, :public, :answered_at, :questionable_id, :questionable_type
  json.url ticket_url(ticket, format: :json)
end
