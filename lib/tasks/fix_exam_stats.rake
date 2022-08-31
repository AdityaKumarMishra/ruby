namespace :fix_exam_stats do
  task update_total_of_stats: :environment do

    stats = ExamStatistic.where("total < ? ",0)

    stats.all.each do |stat|

      tag = Tag.find(stat.tag_id)

      tag_ids = tag.self_and_descendants_ids

      total_ques= stat.section_attempt.section_item_attempts.includes(mcq: { tagging: {} }, mcq_answer: {}).where(taggings: { tag_id: tag_ids })

      total = total_ques.size

      stat.update(total: total)
    end
  end
end
