class RenameRateToRatingToEssayTutorFeedback < ActiveRecord::Migration[6.1]
  def change
    rename_column :essay_tutor_feedbacks, :rate, :rating
  end
end
