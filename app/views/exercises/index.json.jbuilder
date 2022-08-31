json.array!(@exercises) do |exercise|
  json.extract! exercise, :id, :difficulty, :amount, :completed_at, :user_id
  json.url exercise_url(exercise, format: :json)
end
