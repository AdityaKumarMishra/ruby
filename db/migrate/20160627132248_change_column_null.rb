class ChangeColumnNull < ActiveRecord::Migration[6.1]
  def up
    McqStem.where("reviewer_id IS NULL OR author_id IS NULL OR title IS NULL OR description IS NULL").each do |mcq|
      mcq.reviewer_id = 1 if mcq.reviewer_id.nil?
      mcq.reviewed = true if mcq.reviewer_id.nil?
      mcq.author_id = 1 if mcq.author.nil?
      mcq.title = "title" if mcq.title.nil?
      mcq.description = "description" if mcq.description.nil?
      mcq.save


    end

    change_column_null :mcq_stems, :reviewer_id, false
  end


  def down

    change_column_null :mcq_stems, :reviewer_id, true

  end
end
