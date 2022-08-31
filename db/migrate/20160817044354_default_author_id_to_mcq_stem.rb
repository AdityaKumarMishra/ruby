class DefaultAuthorIdToMcqStem < ActiveRecord::Migration[6.1]
  def up
  	McqStem.where(author_id: nil).each do |mcq_stem|
      mcq_stem.author_id = User.find_by(email: "tt@gradready.com.au").id
      mcq_stem.save!
    end
  end

  def down
  end
end
