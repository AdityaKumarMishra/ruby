require 'rails_helper'

RSpec.describe Section, type: :model do
  let(:section) { FactoryGirl.create :section }

  it 'validates title presence' do
    expect(section).to validate_presence_of(:title)
  end 

  it 'validates duration presence' do
    expect(section).to validate_presence_of(:duration)
  end

  it 'validates position presence' do
    expect(section).to validate_presence_of(:position)
  end

  it { should validate_numericality_of(:position) }
  
  it { should have_many(:section_attempts).dependent(:destroy) }
end
