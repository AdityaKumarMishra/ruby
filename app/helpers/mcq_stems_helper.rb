module McqStemsHelper
  def difficulty_to_human difficulty
    if difficulty
      McqStem::DIFFICULTY_LEVELS.each { |level|
        return I18n.t level.first if difficulty.between?(level.second[:bottom], level.second[:top])
      }

      return I18n.t "mixed" if difficulty == -1
    end
    return nil
  end

  def mcq_stem_collection
    [
      ["MCQ Dashboard", "/mcq_stems/mcq_unit_progress_dashboard"],
      ["MCQ Creation Statistics", "/mcq_stems/mcq_creation_progress_statistics" ],
      ["Payment Data - Payroll", "/mcq_stems/payment_data"],
      ["Payment Data - All", "/mcq_stems/payment_data_all"],
      ["MCQ Counter", "/dashboard/mcq_counter"]
    ]
  end

  def select_option_values(action)
    case action
      when 'mcq_unit_progress_dashboard'
        '/mcq_stems/mcq_unit_progress_dashboard'
      when 'mcq_creation_progress_statistics'
        '/mcq_stems/mcq_creation_progress_statistics'
      when 'payment_data'
        '/mcq_stems/payment_data'
      when 'payment_data_all'
        '/mcq_stems/payment_data_all'
      when 'mcq_counter'
        '/dashboard/mcq_counter'
      else
        '/mcq_stems/mcq_unit_progress_dashboard'
      end
  end

  def pool_collection
    [
      ['Exercise', 'exercise'],
      ['Exam', 'exam'],
      ['Tutor-Use', 'tutor_use']
    ]
  end

  def status_collection
    [
      ['Published', 'published'],
      ['Not Published', 'not_published']
    ]
  end

  def work_status_collection
    [
      ['Not Started', 'not_started'],
      ['Initial Writing', 'initial_writing'],
      ['Ready for Review 1', 'ready_for_review_1'],
      ['Rewrites per First Review', 'rewrites_per_first_review'],
      ['Discard', 'discard'],
      ['Ready for Review 2', 'ready_for_review_2'],
      ['(no longer in use) Review 2 Complete', 'review_2_complete'],
      ['Ready for Graphics Designer', 'graphics_briefed'],
      ['Graphics Supplied', 'graphics_supplied'],
      ['Graphics Update Needed', 'graphics_adjustment_needed'],
      ['(no longer in use) Graphics Complete', 'graphics_complete'],
      ['Ready for Video Explainer', 'video_explanation_in_progress'],
      ['Ready for VER', 'video_explanation_complete'],
      ['Video Updated Needed', 'video_explanation_redo'],
      ['Formatting Complete & Published', 'formatting_complete_published']
    ]
  end

  def skill_tags_collection
    SkillTag.all.order(:tag_name).pluck(:tag_name, :id)
    # [
    #   ['Compare and contrast', 'compare_and_contrast'],
    #   ['Deduction, inferences and generalisation', 'deduction_inferences_and_generalisation'],
    #   ['Visualisation and pattern perception', 'visualisation_and_pattern_perception'],
    #   ['Data interpretation, extrapolation and interpolation', 'data_interpretation_extrapolation_and_interpolation'],
    #   ['Calculation and estimation', 'calculation_and_estimation']
    # ]
  end

  def score_collection
    [[0,0],[1,1],[2,2],[3,3],[4,4],[5,5]]
  end

  def difficulty_collection
    collection =  []
    collection.push ['', '']
    collection += McqStem::DIFFICULTY_LEVELS.map { |k, v| [k, v[:default]] }
    collection.to_h
  end

  def appear_in_exam mcq_stem
    exam_title =  []
    if mcq_stem.section_items.present?
      Section.where(id: mcq_stem.section_items.pluck(:section_id).uniq).includes(:sectionable).map(&:sectionable).uniq.each do |t|
        exam_title << t.title
      end
    end
    return exam_title.join(',')
  end

  def average_rating(mcq_stem)
    mcq_avg = RatingCache.mcqs_ratings.joins("LEFT OUTER JOIN   mcqs on rating_caches.cacheable_type = 'Mcq' AND rating_caches.cacheable_id = mcqs.id").where("mcqs.mcq_stem_id  = ? ", mcq_stem.id).collect(&:avg)
    mcq_average_total =  mcq_avg.sum
    mcq_count = Mcq.includes(:mcq_stem).where("mcq_stems.id = ?", mcq_stem.id).references(:mcq_stems).count
    average = (mcq_average_total != 0 &&  mcq_count != 0) ? (mcq_average_total / mcq_count) : 0
    return average.round(1)
  end

  def total_mcq_stem_time(question_time, stem_id)
    return if question_time.nil?
    (question_time * McqStem.find(stem_id).mcqs.count.to_f)
  end

  def display_type_collection
    [
      ['Normal', 'normal'],
      ['Split Screen', 'split_screen'],
      ['Yes No', 'yes_no']
    ]
  end

  def disable_status?(mcq_stem, params, options)
    status = options.include?(:edit_stem) ? mcq_stem.status : params[:mcq_stem].present? && params[:mcq_stem][:status].present? ? params[:mcq_stem][:status] : 'not_published'
    to_disable = false

    if (status == 'published' && mcq_stem.mcqs.present? && OnlineExam.includes(sections: [:section_items])
                                                                     .where(published: true, sections: { section_items: { mcq_id: mcq_stem.mcqs.ids } })
                                                                     .references(sections: [:section_items]).present?)
      to_disable = true
    end

    [status, to_disable]
  end

  def tutors_collections
    User.where.not(role: 0).where.not(first_name: nil).order(:first_name).map{|c| [c.full_name, c.id]}
  end

  def fetch_work_status_mcqs_count(mcq_counts, status)
    mcq_counts[status]
  end

  def progress_work_status_mcqs_count(mcq_counts, total_count, status)
    ((mcq_counts[status].to_f) / (total_count.to_f) * 100).round(2).to_s + "%"
  end

  def total_percentage(mcqs_count, total_count)
    ((mcqs_count.values.sum.to_f) / ((total_count).to_f) * 100).round(2).to_s + "%"
  end

  def default_reviewer
    User.find_by(email: "tt@gradready.com.au")
  end

  def sorted_tutors
    User.where.not(role:0).order(:first_name)
  end

  def video_btn_visibility?
    %w(admin manager superadmin).include? current_user.try(:role)
  end
end
