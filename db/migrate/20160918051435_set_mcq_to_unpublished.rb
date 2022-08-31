class SetMcqToUnpublished < ActiveRecord::Migration[6.1]
  def up
    # This migration sets any mcq_stem with an mcq that has no tags to be set as unpublished
    tagged = Tagging.where("taggings.taggable_type = ?","Mcq").map{|t| t.taggable_id}
    # Grabs all mcqs that have a tag
    (Mcq.where.not(id: tagged)).includes(:mcq_stem).where("mcq_stems.published = ?", true).references(:mcq_stems).map{|m| m.mcq_stem}.uniq.each do |stem|
      # Go through all mcqs that do not have a tag and is not published
      stem.update_column(:published, false)
    #   Update the column to have published false, used update_column as due to constraint of a mcq needs tags being added using update_attribute would have failed

    end
  end
end
