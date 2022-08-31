# == Schema Information
#
# Table name: contact_forms
#
#  id                  :integer          not null, primary key
#  email               :string
#  phone               :string
#  subject             :string
#  message             :text
#  contact_location_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class ContactForm < ApplicationRecord
  belongs_to :contact_location

  validates :email, presence: true, email: true
  validates :phone, presence: true
  validates :subject, presence: true
  validates :message, presence: true
  validates :contact_location_id, presence: true
end
