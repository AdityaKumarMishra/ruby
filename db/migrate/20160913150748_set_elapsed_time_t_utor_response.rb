class SetElapsedTimeTUtorResponse < ActiveRecord::Migration[6.1]
  def up
    EssayTutorResponse.all do |etr|
      etr.update(elapsed_time: 0)
    end
  end
end
