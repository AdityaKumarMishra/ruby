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

require 'rails_helper'

RSpec.describe ContactForm, type: :model do
  it{should validate_presence_of :contact_location_id}
  it{should validate_presence_of :phone}
  it{should validate_presence_of :email}
  it{should validate_presence_of :subject}
  it{should validate_presence_of :message}
end
