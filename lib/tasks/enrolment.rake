namespace :enrolment do
  task :update_feature_enrolments => :environment do
    # Enrolment.all.each do |e|
    #   e.update_enrolled_features
    # end
  end

  task unenroll_all_ft_students_prior_to_4th_july_2022: :environment do
    pv_id = ProductVersion.find_by(name: 'GM 3.1 Free Trial')&.id
    next if pv_id.blank?

    total_enrolments = Enrolment.includes(:product_version)
                                .where("product_versions.id = ? AND state != 3 AND DATE(enrolments.created_at) <= ? ", pv_id, '2022-07-04'.to_date)
                                .references(:product_version)
    puts "Starting unenrolment of #{total_enrolments.count} students\n\n\n"

    total_enrolments.find_each do |e|
      e.update!(state: 'Unenrolled')
    end

    puts "Completed\n\n"
  end

  task unenroll_expired_courses: :environment do
    beg_of_day = Time.zone.now.beginning_of_day
    states = Enrolment.states
    Enrolment.includes(:course).where(
                        "((trial = ? AND trial_expiry < ?)
                        OR
                        (courses.expiry_date < ?))
                        AND state != ?",
                        true,
                        Time.zone.now,
                        beg_of_day,
                        states['Unenrolled']
                      ).references(:courses).update_all(state: states['Unenrolled'])
  end

  task update_ft_orders_to_free: :environment do
    Enrolment.includes(:order)
             .where("enrolments.course_id = 1308 AND orders.status = 2")
             .references(:order).find_each do |e|
      e.order.update(status: :free) if e.order.present?
    end
  end

  task unenroll_remaining_custom_courses: :environment do
    Enrolment.where.not(state: 'Unenrolled')
             .includes(:order)
             .where("trial != true AND orders.status = 6 AND orders.id IS NOT NULL")
             .references(:order)
             .find_each do |e|
      time = e.created_at

      if time.present?
        e.update_column(:trial, true)
        e.update_column(:trial_expiry, time + 7.days)
      end
    end

    Rake::Task["enrolment:unenroll_expired_courses"].invoke
  end

  task unenroll_free_trail_courses: :environment do
    Enrolment.where.not(state: 'Unenrolled')
             .includes(:product_version, :order)
             .where("product_versions.course_type = 0 AND orders.status NOT IN (0, 1)")
             .references(:product_version, :order)
             .find_each do |e|
      time = e.paid_at || e.created_at

      if time.present?
        e.update_column(:trial, true)
        e.update_column(:trial_expiry, time + 7.days)

        if e.user.present? && e.user.orders.present?
          custom_order = e.user.orders.where(status: :registered).first

          if custom_order.present?
            enrolments = []

            custom_order.purchase_items.each { |p| enrolments.push(p.purchasable) if p.purchasable_type == 'Enrolment' }
            enrolments.map do |ee|
              tme = ee.paid_at || ee.created_at

              if tme.present?
                ee.update_column(:trial, true)
                ee.update_column(:trial_expiry, tme + 7.days)
              end
            end
          end
        end
      end
    end

    Rake::Task["enrolment:unenroll_expired_courses"].invoke
  end

  task :update_enrolment_for_gamsat_free_trial => :environment do
    Enrolment.includes(:course).where("courses.trial_enabled = ? AND enrolments.trial = ? AND courses.name = ?", true, true, "GAMSAT Free Trial").references(:courses).each do |enm|
      enm.update(trial_expiry: enm.course.expiry_date, state: 1)
    end
  end

end
