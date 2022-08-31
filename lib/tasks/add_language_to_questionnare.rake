namespace :add_language_to_questionnare do
  task add_language_to_old_questionnare: :environment do
    questionnares = Questionnaire.where(language_spoken: nil)
    questionnares.update_all(language_spoken: 'na') if questionnares.present?
  end
end
