json.array!(@surveys_surveys) do |surveys_survey|
  json.extract! surveys_survey, :id, :user_ids, :title, :date_published, :date_start, :published, :date_closed
  json.url surveys_survey_url(surveys_survey, format: :json)
end
