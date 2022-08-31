namespace :update_live_feature do
  task update_live_exam_feature: :environment do
    features = MasterFeature.where("name LIKE(?)", "%LiveExamFeature%")
    features.each do |feat|
      pro_line = feat.name.split("LiveExamFeature")
      new_name = pro_line.present? ? pro_line[0] + "LiveMockExamFeature" : "LiveMockExamFeature"
      feat.update(name: new_name)
    end
  end
end
