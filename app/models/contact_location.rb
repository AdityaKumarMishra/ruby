# == Schema Information
#
# Table name: contact_locations
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ContactLocation < ApplicationRecord

  has_many :contacts
  has_many :contact_forms

  validates_presence_of :name
end
