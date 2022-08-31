class AddInfoTextToFreeStudyBuddies < ActiveRecord::Migration[6.1]
  def change
    add_column :free_study_buddies, :info_text, :string
  end
end
