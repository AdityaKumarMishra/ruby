class UpdateForeignKey < ActiveRecord::Migration[6.1]
  def change
    # remove the old foreign_key
    remove_foreign_key :essay_tutor_responses, :essay_responses

    # add the new foreign_key
    add_foreign_key :essay_tutor_responses, :essay_responses, on_delete: :cascade
  end
end
