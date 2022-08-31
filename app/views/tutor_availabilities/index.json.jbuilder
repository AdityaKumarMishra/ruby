json.array!(tutor_availabilities) do |tutor_apoitments_date|
  json.extract! tutor_apoitments_date, :id, :user_id, :start_time, :end_time, :repeatability, :location
  json.url tutor_apoitments_date_url(tutor_apoitments_date, format: :json)
end
