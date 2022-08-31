namespace :mcq do
  task add_mcq_attempts_to_exam: :environment do
  	# section_item_attempts = SectionItemAttempt.where('DATE(created_at) >= ?', '01/01/2021'.to_date)
  	# section_item_attempts.each do |section_item_attempt|
  	# 	mcq_attempt = section_item_attempt.section_attempt.mcq_attempts.find_or_create_by(mcq_stem: section_item_attempt.mcq_stem, mcq: section_item_attempt.mcq, user: section_item_attempt.user, section_item_id: section_item_attempt.section_item_id,  mcq_answer_id: section_item_attempt.mcq_answer_id )
  	# 	puts "=======================#{mcq_attempt.id}=============="
  	# end

    distict_stats = ActiveRecord::Base.connection.execute("SELECT DISTINCT ON (user_id, tag_id, course_id, section_attempt_id) * FROM exam_statistics")
    ids = distict_recs.to_a.map{|x| x["id"]} 
    duplicate_stats = countt = ExamStatistic.where("id NOT IN (?)", ids) 
    duplicate_stats.destroy_all

  	exam_stats = ExamStatistic.where('total < 0')
  	exam_stats.each_with_index do |stat, index|
  		total = attempts_with_tags(stat.tag, stat)
  		result = stat.update(total: total.count)
  		puts "========================#{result}==================="
  		puts "=========================#{index}==================="
  	end

  	incorrect_ids = ExamStatistic.where('incorrect > total').pluck(:id)
  	correct_ids = ExamStatistic.where('correct > total').pluck(:id)
  	total_ids  = ExamStatistic.where('(incorrect+correct) > total').pluck(:id)
  	exam_stats = ExamStatistic.where(id: (incorrect_ids + correct_ids +  total_ids).flatten.uniq)

  	exam_stats.each_with_index do |stat, index|
  		puts "=========================#{index}==================="
  		user = stat.user
  		if user.present?
  			exam_stat = fetch_user_exam_stats(stat.tag, stat.section_attempt_id, user, stat)
  				if exam_stat.present?
              puts "=========================#{exam_stat.id}============"
  				    if (exam_stat.correct + exam_stat.incorrect) > exam_stat.total
  					       puts"=============ERROR==============="
  				    end
          end
  		end
  	end
  end


  def attempts_with_tags tag, stat
		section_attempt = stat.section_attempt
		tag_ids = tag.self_and_descendants_ids
		section_attempt.section_item_attempts.includes(mcq: { tagging: {} }, mcq_answer: {}).where(taggings: { tag_id: tag_ids })
	end

	def fetch_user_exam_stats(sec_tag = nil, sec_id, user, exam_statistic)
    sec_attempt = user.section_attempts.find(sec_id)
    if exam_statistic.present?
      tag_ids = sec_tag.self_and_descendants_ids

      section_item_attempt_temp = sec_attempt.section_item_attempts.includes(mcq: { tagging: {} }, mcq_answer: {})

      correct_ans = section_item_attempt_temp.where(mcq_answers: { correct: true })
		  correct_ans = correct_ans.where(taggings: { tag_id: tag_ids }) if sec_tag.present?
		  correct = correct_ans.size

		  incorrect_ans = section_item_attempt_temp.where(mcq_answers: { correct: false })
		  incorrect_ans = incorrect_ans.where(taggings: { tag_id: tag_ids }) if sec_tag.present?
		  incorrect = incorrect_ans.size

		  # total_ques = sec_attempt.section_item_attempts.includes(mcq: { tagging: {} }, mcq_answer: {})
		  # total_ques = total_ques.where(taggings: { tag_id: tag_ids })  if sec_tag.present?
		  total_ques = section_item_attempt_temp.where(taggings: { tag_id: tag_ids })
		  total = total_ques.size

		  # section_item_attempts = section_item_attempt_temp.select{|att| att.mcq.try(:tags).try(:any?){|t| t.self_and_ancestors.include?(sec_tag) if t }}
		  # mcq_ids = section_item_attempts.collect{|m| m.mcq_stem_id}
		  # time_taken = sec_attempt.mcq_attempt_times.where(mcq_stem_id: mcq_ids).sum(:total_time)

		  is_updated = exam_statistic.update(total: total, incorrect: incorrect, correct: correct)

      puts "==========#{is_updated}============="
    end
    exam_statistic
  end
end