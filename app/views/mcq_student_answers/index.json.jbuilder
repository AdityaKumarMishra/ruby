json.array!(@mcq_student_answers) do |mcq_student_answer|
  json.extract! mcq_student_answer, :id, :title, :description, :mcq_answer_id, :user_id, :time_taken
  json.url mcq_student_answer_url(mcq_student_answer, format: :json)
end
