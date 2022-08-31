namespace :create_free_gamsat_trial_for_main_page do
  task create_free_gamsat_trial: :environment do
    FreeStudyBuddy.create!(title: "GAMSAT Free Trial", info_text: "Test our Industry-Leading LMS for yourself with 50 free MCQs & more!",button_text: "Signup Now", description: " Free Gamsat Trial Sign Up On Main Page")
  end
end
