namespace :mcq do
  desc 'Removes html tags from answers'
  task strip_html_answers: :environment do
    McqAnswer.where.not(answer: nil).find_each do |ma|
      ma.answer = ActionView::Base.full_sanitizer.sanitize(ma.answer)
      ma.save
    end
  end
  desc "removes any letters like 'A)' from start of question"
  task strip_leading_letters: :environment do
    McqAnswer.where.not(answer: nil).find_each do |ma|
      if ma.answer.size > 2
        substring = ma.answer[0..2]
        if substring.include? 'a)'
          ma.answer = ma.answer.sub('a)', '')
        end
        if substring.include? 'A)'
          ma.answer = ma.answer.sub('A)', '')
        end
        if substring.include? 'b)'
          ma.answer = ma.answer.sub('b)', '')
        end
        if substring.include? 'B)'
          ma.answer = ma.answer.sub('B)', '')
        end
        if substring.include? 'c)'
          ma.answer = ma.answer.sub('c)', '')
        end
        if substring.include? 'C)'
          ma.answer = ma.answer.sub('C)', '')
        end
        if substring.include? 'd)'
          ma.answer = ma.answer.sub('d)', '')
        end
        if substring.include? 'D)'
          ma.answer = ma.answer.sub('D)', '')
        end
        if substring.include? 'a.'
          ma.answer = ma.answer.sub('a.', '')
        end
        if substring.include? 'A.'
          ma.answer = ma.answer.sub('A.', '')
        end
        if substring.include? 'b.'
          ma.answer = ma.answer.sub('b.', '')
        end
        if substring.include? 'B.'
          ma.answer = ma.answer.sub('B.', '')
        end
        if substring.include? 'c.'
          ma.answer = ma.answer.sub('c.', '')
        end
        if substring.include? 'C.'
          ma.answer = ma.answer.sub('C.', '')
        end
        if substring.include? 'd.'
          ma.answer = ma.answer.sub('d.', '')
        end
        if substring.include? 'D.'
          ma.answer = ma.answer.sub('D.', '')
        end
        ma.save
      end
    end
  end

  desc "remove div tags from mcqs"
  task strip_div_tags: :environment do
    Mcq.where.not(question: nil).find_each do |mcq|
      mcq.question = ActionController::Base.helpers.sanitize( mcq.question, tags: %w('div')).chomp
      mcq.save
    end
  end

  desc "It replaces answers like A) to A "
  task fix_incorrect_answers: :environment do
    McqAnswer.where.not(answer: nil).find_each do |ma|
      if ma.answer.size < 4
        substring = ma.answer.downcase
        if substring.include? 'a)' || substring == 'a'
          ma.answer = 'A'
        end
        if substring.include? 'b)' || substring == 'b'
          ma.answer = 'B'
        end
        if substring.include? 'c)' || substring == 'c'
          ma.answer = 'C'
        end
        if substring.include? 'd)' || substring == 'd'
          ma.answer = 'D'
        end
        if substring.include? 'e)' || substring == 'e'
          ma.answer = 'E'
        end
        if substring.include? 'f)' || substring == 'f'
          ma.answer = 'F'
        end
        if substring.include? 'a.'
          ma.answer = 'A'
        end
        if substring.include? 'b.'
          ma.answer = 'B'
        end
        if substring.include? 'c.'
          ma.answer = 'C'
        end
        if substring.include? 'd.'
          ma.answer = 'D'
        end
        if substring.include? 'e.'
          ma.answer = 'E'
        end
        if substring.include? 'f.'
          ma.answer = 'F'
        end
        ma.save
      end
    end
  end

  def correct_answer mcq_answer
    alphabet = ("A".."Z").to_a
    alphabet[mcq_answer.mcq.mcq_answers.index(mcq_answer)]
  end

  desc "deletes obsolete answers"
  task delete_empty_mcq_answers: :environment do
    McqAnswer.where(mcq: nil).find_each do |ma|
      ma.destroy
    end
  end

  desc "sets the mcq_answer when its ' '"
  task reset_mcq_answers: :environment do
    McqAnswer.where(answer: "&nbsp;").find_each do |mcq_answer|
      mcq_answer.answer = correct_answer(mcq_answer)
      mcq_answer.save
    end
  end
end
