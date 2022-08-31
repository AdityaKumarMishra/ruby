namespace :remove_duplicate_essay_tutor_response do
  task fetch_details: :environment do
    dups = EssayTutorResponse.group(:essay_response_id).having('count("essay_response_id") > 1').count
    dups.each do |key, value|
      duplicates = EssayTutorResponse.where(essay_response_id: key)[1..value-1]
      duplicates.each(&:destroy)
    end
  end
end
