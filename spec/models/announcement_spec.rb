require 'rails_helper'

RSpec.describe Announcement, type: :model do
  subject(:announcement) { FactoryGirl.build(:announcement) }

  it { expect(announcement).to validate_uniqueness_of(:name) }
end
