class RenameRateToRatingToEssayTutorResponse < ActiveRecord::Migration[6.1]
  def up
    rename_column :essay_tutor_responses, :rate, :rating
  end

end
