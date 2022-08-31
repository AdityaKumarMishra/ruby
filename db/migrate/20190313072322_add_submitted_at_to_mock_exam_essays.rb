class AddSubmittedAtToMockExamEssays < ActiveRecord::Migration[6.1]
  def change
    add_column :mock_exam_essays, :submitted_at, :datetime
  end
end
