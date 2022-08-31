# This task for change Exam 1 and Exam 2 title
namespace :change_exam1_and_exam2_name do
  task exam_name: :environment do
    puts "=============== Task Start ==============="
    MasterFeature.find_by(name: "GamsatOnlineMockExamFeature2").update(title: "Live Mock Exam")
    MasterFeature.find_by(name: "GamsatOnlineMockExamFeature1").update(title: "Home Mock Exam Day")
     puts "=============== Task End ==============="
  end
end
