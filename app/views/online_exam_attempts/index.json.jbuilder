json.array!(@online_exam_attempts) do |online_exam_attempt|
  json.extract! online_exam_attempt, :id, :user_id, :online_exam_id, :percentile, :mark, :completed_at
  json.url online_exam_attempt_url(online_exam_attempt, format: :json)
end
