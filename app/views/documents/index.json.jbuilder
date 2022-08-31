json.array!(@documents) do |document|
  json.extract! document, :id, :accessible, :for_timetable, :allow_dummy, :only_dummy, :user_id, :for_paid, :for_trial
  json.url document_url(document, format: :json)
end
