namespace :update_mcq_stat do
  task added_correct_per_to_stats: :environment do
    McqStatistic.all.each do |stat|

      mcq_attempts1 = stat.user.mcq_attempts.includes(:exercise).where.not(exercises: { completed_at: nil }).where(exercises: {course_id: stat.course_id})

      tag = Tag.find(stat.tag_id)
      tag_ids = tag.self_and_descendants_ids

      incorrect = mcq_attempts1
                  .joins(:mcq_answer, mcq_stem: :taggings)
                  .where(mcq_stems: { published: true }, taggings: { tag_id: tag_ids }, mcq_answers: { correct: false })
                  .size
      attempted = stat.correct + incorrect

      correct_per = attempted > 0 ? (stat.correct.to_f / attempted * 100).round(2) : 0

      stat.update(incorrect: incorrect, correct_per: correct_per)
    end
  end

end
