class CreateFreeStudyBuddies < ActiveRecord::Migration[6.1]
  def change
    create_table :free_study_buddies do |t|
      t.string :title
      t.string :button_text
      t.string :description
      t.boolean :active, default: false

      t.timestamps null: false
    end
  end
end
