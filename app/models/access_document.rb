# == Schema Information
#
# Table name: access_documents
#
#  id                     :integer
#  last_accessed          :datetime
#  document_id            :integer
#  user_id                :integer
#  created_at             :datetime
#  updated_at             :datetime
#

class AccessDocument < ApplicationRecord
  belongs_to :document
  belongs_to :user

  def set_last_accessed
    self.update_attribute(:last_accessed, DateTime.now)
  end

end
