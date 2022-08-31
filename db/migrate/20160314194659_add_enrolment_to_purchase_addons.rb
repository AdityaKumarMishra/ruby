class AddEnrolmentToPurchaseAddons < ActiveRecord::Migration[6.1]
  def change
    add_reference :purchase_addons, :enrolment, index: true, foreign_key: true
  end
end
