json.array!(@tutor_schedules) do |tutor_schedule|
  json.extract! tutor_schedule, :id, :repeatability, :start_time, :end_time, :location
  json.url tutor_schedule_url(tutor_schedule, format: :json)
end
