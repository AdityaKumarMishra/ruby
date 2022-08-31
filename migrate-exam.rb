def map_diff(d_str)
  if d_str == 'easy'
    return 1
  end
  if d_str == 'medium'
    return 50
  end
  if d_str == 'hard'
    return 100
  end
end



File.open("./exam.json","w") do |f|
  Online::Exam.each do |e|
    exam = {}
    exam[:title] = e.title
    exam[:instruction] = e.instruction
    if e.state == "published"
      exam[:published] = true
    else
      exam[:published] = false
    end

    exam[:sections] = []
    if e.sections.count > 0

      e.sections.each_with_index do |s,m|
        e[:sections][m] = {}
        e[:sections][m][:title] = s.title
        e[:sections][m][:position] = s.position
        e[:sections][m][:duration] = s.duration

        q = s.questions
        e[:sections][m][:questions] = []
        for k in 0 ... q.count
          t = {}
          t[:stem_mcq] = {title: q[k].title,
                          description: q[k].text,
                          tag: q[k].tags.first.name}

          if q[k].state == "published"
            t[:stem_mcq][:published] = true
          else
            t[:stem_mcq][:published] = false
          end
          t[:stem_mcq][:difficulty] = map_diff(q[k].difficulty_levels)

          t[:child_mcqs] = []
          q[k].sub_questions.each_with_index do |x,i|
            t[:child_mcqs][i] = {}
            t[:child_mcqs][i][:description] = x.text
            t[:child_mcqs][i][:explanation] = x.answer_explanation
            t[:child_mcqs][i][:rating] = x.sub_question_avg_rating
            t[:child_mcqs][i][:answers] = []
            t[:child_mcqs][i][:answers] = x.answers.map { |a| {description: a.text, correct: a.correct} }

          end
          e[:sections][m][:questions].push t
        end
      end
    end
    f.write(exam.to_json)
    f.write("\n")
  end
  f.close
end