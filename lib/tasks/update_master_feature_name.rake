namespace :update_master_feature_name do
  task fetch_details: :environment do
    puts "=============== Task Start ==============="
      MasterFeature.find_by(name: "GamsatDocumentsFeature").update(title: "Written Resources")
      MasterFeature.find_by(name: "GamsatTextbookFeature").update(title: "Textbook - Online")
      MasterFeature.find_by(name: "GamsatTextbookHardCopyFeature").update(title: "Textbook - Hard Copy")
      MasterFeature.find_by(name: "GamsatWeekendCourse").update(title: "Weekend Course - GAMSAT")
    puts "=============== Task End ==============="
  end
end
