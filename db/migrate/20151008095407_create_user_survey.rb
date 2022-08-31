class CreateUserSurvey < ActiveRecord::Migration[6.1]
  def change
    create_table :user_surveys do |t|
      t.references :user, index: true, foreign_key: true
      t.references :survey, index: true, foreign_key: true
    end
    remove_column :surveys, :user_id
  end
end
