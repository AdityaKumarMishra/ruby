class RemoveObsoleteEnrolment < ActiveRecord::Migration[6.1]
  def up
    Enrolment.where(user:nil).each do |enrolment|
      enrolment.deactivate
    end
  end

  def down
  end
end
