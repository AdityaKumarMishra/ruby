# This task update GamsatLiveMockExamFeature to GamsatOnlineMockExamFeature2 stage site
namespace :update_mock_exam do
  task mock_exam: :environment do
    puts "=============== Task Start ==============="
    # MasterFeature.find_by(name: "GamsatLiveMockExamFeature").update(name: "GamsatOnlineMockExamFeature2", title: "Home Mock Exam Day 2", url: "online_mock_exam_attempt_temps_path", icon: "fa fa-file")
    # MasterFeature.find_by(name: "GamsatOnlineMockExamFeature").update(name: "GamsatOnlineMockExamFeature1", title: "Home Mock Exam Day 1")

    # For Reverting task
    MasterFeature.find_by(name: "GamsatOnlineMockExamFeature2").update(name: "GamsatLiveMockExamFeature", title: "Mock Exam", url: "live_exams_path", icon: "fa fa-pencil")
    MasterFeature.find_by(name: "GamsatOnlineMockExamFeature1").update(name: "GamsatOnlineMockExamFeature", title: "Home Mock Exam Day")
     puts "=============== Task End ==============="
  end
end
