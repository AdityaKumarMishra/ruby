class McqAttemptAnsService < ApplicationService

	def initialize(params, current_user)
		@params = params
		@exercise = current_user.exercises.find_by(id: @params[:exercise_id])
	end

	def update_answer(current_course)
		@exercise.mcq_attempts.update(@params[:mcq_attempts].keys, @params[:mcq_attempts].values)
    if @exercise.finish!
      @exercise.update_attribute(:amount, @exercise.mcq_attempts.count)
      @exercise.update_mcq_statistics(current_course)
    end
    return @exercise
	end

	def update_attempt_answer(mcq_attempt,mcq_attempt_params)
    @params[:mcq_attempt_answeres].values.map{|x| x["value"]= eval(x["value"])}
    attempt_answeres = mcq_attempt.mcq_attempt_answers
    if attempt_answeres.present?
      @params[:mcq_attempt_answeres].values.each do |value_hash|
        ans = attempt_answeres.find_or_initialize_by(mcq_answer_id: value_hash["mcq_answer_id"])
        if ans.present?
          ans.update(value: value_hash["value"])
        end
      end
    else
      mcq_attempt.mcq_attempt_answers.create(@params[:mcq_attempt_answeres].values)
    end
	end

	def update_mcq_answer(mcq_attempt_params)
    result = false
    if !@params[:mcq_attempt].nil?
      if @exercise.mcq_attempts.update(mcq_attempt_params.keys, mcq_attempt_params.values)
        result = true
      end
    end
    return result
  end

	  
  def destroy
    mcq_attempt = McqAttempt.find_by(id: @params[:id])
    m_id = nil
    if mcq_attempt.destroy
      m_id = @params[:id]
    end
    return m_id, true
  end
end