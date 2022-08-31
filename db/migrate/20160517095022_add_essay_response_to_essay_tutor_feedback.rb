class AddEssayResponseToEssayTutorFeedback < ActiveRecord::Migration[6.1]
  def change
    add_reference :essay_tutor_feedbacks, :essay_response, index: true, foreign_key: true
  end
end
