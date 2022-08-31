namespace :popular_master_feature do
  task add_popularity: :environment do
    MasterFeature.all.each do |master_feature|
      if master_feature.live_exam? || master_feature.get_clarity? || master_feature.mcq_feature? || master_feature.exam_feature?
        if master_feature.get_clarity?
          master_feature.update(most_popular: true, popular_order: 0)
        elsif master_feature.live_exam?
          master_feature.update(most_popular: true, popular_order: 1)
        elsif master_feature.mcq_feature?
          master_feature.update(most_popular: true, popular_order: 2)
        else
          master_feature.update(most_popular: true, popular_order: 3)
        end
      end
    end
  end
end
