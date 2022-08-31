class DeleteNullEssays < ActiveRecord::Migration[6.1]
  def up
    EssayResponse.where(user:nil).each do |er|
      er.destroy
    end
  end

  def down

  end
end
