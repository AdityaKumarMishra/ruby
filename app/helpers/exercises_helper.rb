module ExercisesHelper
  def tag_level(tag)
    level = 0
    leaf_tag = 0
    leaf_tag += 1 unless Tag.where(parent_id: tag.id).count > 0
    until tag.parent.nil?
      tag = tag.parent
      level += 1
    end
    [level, leaf_tag]
  end

  def tag_level_row_style(level, leaf_tag, score, viewed=nil)
    return if viewed.present? && viewed == 0
    score = score.to_i
    if leaf_tag >= 0
      if score >= 0 && score < 50
        'color_red'
      elsif score >= 50 && score < 70
        'color_orange'
      elsif score >= 70 && score <= 100
        'color_green'
      end
    end
  end

  def score_by_tag(statistics, tag)
    correct_mcq = statistics[tag.id]['correct_mcq_by_tag'].to_f
    viewed_mcq = statistics[tag.id]['viewed_mcq_by_tag'].to_f
    (correct_mcq / viewed_mcq * 100).nan? ? '0.0%' : number_to_percentage((correct_mcq / viewed_mcq * 100), precision: 1)
  end

  def score_by_tag_statistics(tag, by_tag_correct, by_tag_total)
    correct_mcq = by_tag_correct.to_f
    (correct_mcq / by_tag_total * 100).nan? ? '0.0%' : number_to_percentage((correct_mcq / by_tag_total * 100), precision: 1)
  end

  def total_mcq_by_tag(statistics, tag)
    statistics[tag.id]['total_mcq_by_tag']
  end

  def viewed_mcq_by_tag(statistics, tag)
    statistics[tag.id]['viewed_mcq_by_tag']
  end

  def correct_mcq_by_tag(statistics, tag)
    statistics[tag.id]['correct_mcq_by_tag']
  end

  def get_difficulties
    difficulty_titles = { easy: 'Easy',
                          medium: 'Medium',
                          hard: 'Hard',
                          mixed: 'Mix of All Difficulty Levels' }
    Exercise.difficulties.keys.map { |k| [difficulty_titles[k.to_sym], k] }
  end

  def tag_level_padding(level)
    level == 2 ? 'tag-level2-padding' : level == 1 ? 'tag-level1-padding' : ''
  end
end
