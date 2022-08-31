module McqAttemptsHelper
  def filter_mcq_stems(exercise, question=nil)
    if exercise.present?
      mcq_stems = if question.present?
                    exercise.mcq_stems.where(id: question).uniq
                  else
                    exercise.mcq_stems.sort.uniq
                  end
      return mcq_stems
    end
  end

  def filter_mcq_stems_with_tag(exercise, tag)
    exercise.mcq_stems.joins(mcqs: [:tag]).where('tags.id in (?)', tag.children.pluck(:id)).uniq
  end

  def list_alphabet_style
    [*("A.".."Z.")]
  end

  def list_exam_alphabet_style(index, question=nil, lbl_for=nil)

    "<label for='#{lbl_for}' class='ans_option_text' style='display: inline-block!important;'>#{question}</label>"
  end

  def ucat_list_exam_alphabet_style (index, question=nil, lbl_for=nil)
     "<label for='#{lbl_for}'>#{question}</label>"
  end

  def list_exam_alphabet_style_ucat(index, question=nil, lbl_for=nil)

    "<label for='#{lbl_for}' class='a_text'>#{question}</label>"
  end

  def get_sections(exercise)
    tags = exercise.tags.where.not(parent_id: nil).group_by(&:parent)
    return tags.keys.reject{|x| x if x.parent_id.blank?}
  end

  def tag_question_count(tag, exercise)
    exercise.mcqs.joins(:tagging).where('taggings.tag_id in (?)', tag.children.pluck(:id)).count
  end

  def video_watched(mcq_video)
    return UserVideo.find_by(mcq_id: mcq_video.mcq_id, user_id: current_user.id, mcq_video_id: mcq_video.id).present?
  end
end
