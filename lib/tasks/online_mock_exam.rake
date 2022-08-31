namespace :online_mock_exam do
  task create_online_mock_exam_feature: :environment do
    MasterFeature.create(name: "GamsatOnlineMockExamFeature", title: "Online Mock Exam", url: "online_mock_exam_attempts_path", icon: "fa fa-file", show_in_sidebar: true, types: ["GamsatReady"])
  end
end
