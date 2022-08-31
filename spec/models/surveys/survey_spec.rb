# == Schema Information
#
# Table name: surveys
#
#  id             :integer          not null, primary key
#  title          :string
#  date_published :datetime
#  date_start     :datetime
#  published      :boolean
#  date_closed    :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  slug           :string
#

require 'rails_helper'

RSpec.describe Surveys::Survey, type: :model do

  it { should have_many :users }

  it { should validate_presence_of :title }
  it { should validate_presence_of :date_start }
  it { should validate_presence_of :date_closed }
end
