class AddLanguageSpokenToQuestionnaires < ActiveRecord::Migration[6.1]
  def change
  	add_column :questionnaires, :language_spoken, :string
  end
end
