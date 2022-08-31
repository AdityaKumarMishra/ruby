class CreateUserStats < ActiveRecord::Migration[6.1]
  def change
    create_table :user_stats do |t|

      t.float :stuent_stat, default: 0.0
      t.float :average_stat, default: 0.0
      t.integer :user_id
      t.integer :tag_id
      t.integer :course_id
      t.references :viewable, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
