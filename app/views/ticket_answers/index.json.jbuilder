json.array!(@ticket_answers) do |ticket_answer|
  json.extract! ticket_answer, :id, :content, :ticket_id, :user_id, :public, :helpfulness
  json.url ticket_answer_url(ticket_answer, format: :json)
end
