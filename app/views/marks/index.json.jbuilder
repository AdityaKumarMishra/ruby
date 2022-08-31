json.array!(@marks) do |mark|
  json.extract! mark, :id, :value, :correct, :user_id, :essay_response_id, :mcq_student_answer_id, :description
  json.url mark_url(mark, format: :json)
end
