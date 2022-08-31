class AddContentTagIdToApplicationAnswers < ActiveRecord::Migration[6.1]
  def change
  	add_column :application_answers, :content_tag, :string
  end
end
