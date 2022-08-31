json.array!(@diagnostic_test_attempts) do |diagnostic_test_attempt|
  json.extract! diagnostic_test_attempt, :id, :user_id, :assessable_id, :assessable_type, :mark, :percentile, :completed_at
  json.url diagnostic_test_attempt_url(diagnostic_test_attempt, format: :json)
end
