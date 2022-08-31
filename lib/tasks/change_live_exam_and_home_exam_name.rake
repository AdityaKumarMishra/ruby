# This task for change Exam 1 and Exam 2 title
namespace :change_live_exam_and_home_exam_name do
  task name_changes: :environment do
    puts "=============== Task Start ==============="
    MasterFeature.find_by(name: "GamsatOnlineMockExamFeature2").update(title: "Online Mock Exam 1")
    MasterFeature.find_by(name: "GamsatOnlineMockExamFeature1").update(title: "Online Mock Exam 2")
     puts "=============== Task End ==============="
  end
end
