namespace :mcq_count_fix_task do
  task mcq_examinable_update_task: :environment do
    McqStem.all.each do |stem|
      stem.mcqs.update_all(examinable:stem.examinable, publish: stem.published)
    end
  end
end

