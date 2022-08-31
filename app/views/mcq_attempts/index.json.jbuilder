json.array!(@mcq_attempts) do |mcq_attempt|
  json.extract! mcq_attempt, :id, :exercise_id, :mcq_stem_id, :mcq_id, :mcq_answer_id
  json.url mcq_attempt_url(mcq_attempt, format: :json)
end
