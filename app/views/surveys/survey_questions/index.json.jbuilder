json.array!(@surveys_survey_questions) do |surveys_survey_question|
  json.extract! surveys_survey_question, :id, :survey_id, :question
  json.url surveys_survey_question_url(surveys_survey_question, format: :json)
end
