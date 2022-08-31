namespace :update_mcq_stem do
  task fetch_details: :environment do
    puts "=============== Task Start ==============="

    McqStem.all.each do |mcq_stem|
      if mcq_stem.published == true && mcq_stem.examinable == true
        mcq_stem.assign_attributes({
          status: 0,
          pool: 1,
          work_status: 2
        })
        mcq_stem.save(validate: false)
      elsif mcq_stem.published == true && mcq_stem.examinable == false
        mcq_stem.assign_attributes({
          status: 0,
          pool: 0,
          work_status: 2
        })
        mcq_stem.save(validate: false)
      elsif mcq_stem.published == false && mcq_stem.examinable == true
        mcq_stem.assign_attributes({
          status: 1,
          pool: 1,
          work_status: 2
        })
        mcq_stem.save(validate: false)
      elsif mcq_stem.published == false && mcq_stem.examinable == false
        mcq_stem.assign_attributes({
          status: 1,
          pool: 0,
          work_status: 2
        })
        mcq_stem.save(validate: false)
      end
    end

    puts "=============== Task End ==============="
  end

  task update_mcq_stem_work_status_updated_at: :environment do
    McqStem.update_all(work_status_updated_at: Time.zone.now - 1000.days)
  end
end
