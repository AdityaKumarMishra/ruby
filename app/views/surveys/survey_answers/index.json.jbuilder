json.array!(@surveys_survey_answers) do |surveys_survey_answer|
  json.extract! surveys_survey_answer, :id, :user_id, :survey_question_id, :answer, :rating
  json.url surveys_survey_answer_url(surveys_survey_answer, format: :json)
end
