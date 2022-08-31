module EssaysHelper
  def truncate_essay_question(essay, length)
    return truncate(strip_tags(essay.question), length: length, omission: '...')
  end

  def essay_dropdown
    [
      ["Essay Marking Details", "/essay_responses/to_mark"],
      ["Essay Marking Timeline", "/essay_responses/tutor_essays"]
    ]
  end

  def essays_select_option_values(action)
    case action
      when 'to_mark'
        '/essay_responses/to_mark'
      when 'tutor_essays'
        '/essay_responses/tutor_essays'
      else
        '/essay_responses/to_mark'
      end
  end

end

