# == Schema Information
#
# Table name: areas
#
#  id               :integer          not null, primary key
#  city             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  institution_name :string
#

require 'rails_helper'

RSpec.describe Area, type: :model do
  subject(:area) { FactoryGirl.build(:area) }

  it 'has valid :area factory' do
    expect(area).to be_valid
  end

  it { expect(area).to validate_presence_of :city }
  it { expect(area).to validate_uniqueness_of(:city) }
end
