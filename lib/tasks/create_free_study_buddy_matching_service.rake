namespace :create_free_study_buddy_matching_service do
  task create_free_study_buddy_matching_service: :environment do
    if FreeStudyBuddy.all.blank?
      FreeStudyBuddy.create!(title: "Free Study Buddy", info_text: "Matching Service",  button_text: "More Info/Sign Up", description: "Be matched up and succeed with 1 or more of the thousands of students who use GradReady's services every year!<br/>Studying for the GAMSAT is easier, more enjoyable, and more successful with a study buddy or group. It can sometimes be tricky finding the right study buddy, which is why we are here to help by matching you up with one or more buddies based on your area and study preferences! To sign up to the free program, fill out this form <a href = 'https://docs.google.com/forms/d/e/1FAIpQLSdVmH0589ACP60ibjk6CMuyXkWmB4LhtIOVo2SQajT4G17BDQ/viewform'>here</a>")
    else
      FreeStudyBuddy.first.update(title: "Free Study Buddy", info_text: "Matching Service");
    end
  end
end
