namespace :create_weekend_master_feature do
  desc "Create 2 day weekend course"
  task create_master_feature: :environment do
    m = MasterFeature.new(name: 'GAMSATWeekendCourse', title: 'GAMSAT Weekend Course',  types: ["GamsatReady"], show_in_sidebar: false)
    m.save
  end
end
