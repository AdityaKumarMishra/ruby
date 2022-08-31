# == Schema Information
#
# Table name: video_categories
#
#  id         :integer          not null, primary key
#  name       :string
#  subject_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe VideoCategory, type: :model do
  it {should validate_presence_of :name}
  it {should validate_presence_of :subject_id}
end
