class AddOptionsToFeatureEnrolments < ActiveRecord::Migration[6.1]
  def change
    add_column :feature_enrolments, :options, :text, default: '{}'
  end
end
