class AddIsSubmitedToUserSurvey < ActiveRecord::Migration[6.1]
  def change
    add_column :user_surveys, :is_submited, :boolean
  end
end
