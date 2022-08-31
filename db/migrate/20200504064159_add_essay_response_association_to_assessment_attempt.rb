class AddEssayResponseAssociationToAssessmentAttempt < ActiveRecord::Migration[6.1]
  def self.up
    add_column :essay_responses, :assessment_attempt_id, :integer
  end

  def self.down
    remove_column :essay_responses, :assessment_attempt_id
  end
end
