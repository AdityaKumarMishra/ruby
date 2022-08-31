class FixUserReferenceInMcqAttempt < ActiveRecord::Migration[6.1]
  def change
    McqAttempt.find_each do |m|
      if m.user_id != m.exercise.user_id
        m.user_id = m.exercise.user_id
        m.save
      end
    end
  end
end
