# == Schema Information
#
# Table name: contact_locations
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe ContactLocation, type: :model do
  it{should validate_presence_of :name}
end
