# == Schema Information
#
# Table name: contacts
#
#  id                  :integer          not null, primary key
#  name                :string
#  position            :string
#  email               :string
#  visible             :boolean
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  avatar_file_name    :string
#  avatar_content_type :string
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  contact_location_id :integer
#

require 'rails_helper'

RSpec.describe Contact, type: :model do
  it{should validate_presence_of :contact_location_id}
  it{should validate_presence_of :name}
  it{should validate_presence_of :email}
  it{should validate_presence_of :avatar}
end
