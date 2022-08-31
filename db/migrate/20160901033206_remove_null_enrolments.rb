class RemoveNullEnrolments < ActiveRecord::Migration[6.1]
  def up
    Enrolment.includes(:purchase_item).where({purchase_items: {id: nil}}).each do |enrolment|
      enrolment.destroy!
    end
  end
end
