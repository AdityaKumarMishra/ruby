namespace :create_online_mock_feature do
  task online_mock_exam_feature: :environment do
    m = MasterFeature.new(name: 'GamsatOnlineMockExamFeature', title: 'Online Mock Exam',  types: ["GamsatReady"], show_in_sidebar: false)
    m.save
  end
end
