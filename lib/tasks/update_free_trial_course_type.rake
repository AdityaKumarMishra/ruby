namespace :update_free_trial_course_type do
  task update_free_trial_course_type_to_freemium: :environment do
    ProductVersion.where(course_type: 10).each do |pv|
      pv.courses.update_all(trial_enabled: true, trial_period_days: 134)
    end
  end

  # Update course_type nil to 0 Free Online Exams
  task update_course_type_of_free_online: :environment do
    pv = ProductVersion.find_by_id(84)
    pv.update(course_type: 0)
    end

  # Update freemium false to true Free Online Exams
  task update_freemium_for_free_course: :environment do
    ProductVersion.where(course_type: [0,10]).each do |pv|
      pv.update(freemium: true)
    end
  end

  # upadte free study guide to fremium for gamsat
  task update_freemium_for_gamsat_user_enrolment: :environment do
    Enrolment.where(course_id: 553).each do |enrol|
      unless enrol.trial
        enrol.update(trial: true, trial_expiry: (Date.today + 130))
      end
    end
  end

  # upadte free study guide to fremium for umat
  task update_freemium_for_umat_user_enrolment: :environment do
    Enrolment.where(course_id: 554).each do |enrol|
      unless enrol.trial
        enrol.update(trial: true, trial_expiry: (Date.today + 130))
      end
    end
  end

end
