require 'rails_helper'

RSpec.describe Mark, type: :model do
  subject(:mark) { FactoryGirl.build(:mark) }

  it 'has valid :mark factory' do
    expect(mark).to be_valid
  end

  it { expect(mark).to belong_to :user }

  it { expect(mark).to validate_presence_of :value }
  it { expect(mark).to validate_presence_of :user_id }

  it { expect(mark).to validate_inclusion_of(:description).in_array(['Easy', 'Medium', 'Hard']) }
end
