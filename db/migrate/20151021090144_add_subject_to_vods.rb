class AddSubjectToVods < ActiveRecord::Migration[6.1]
  def change
    add_reference :vods, :subject, index: true, foreign_key: true
  end
end
