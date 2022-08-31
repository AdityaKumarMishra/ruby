# == Schema Information
#
# Table name: addresses
#
#  id              :integer          not null, primary key
#  number          :integer
#  street_name     :string
#  street_type     :string
#  subburb         :string
#  city            :string
#  post_code       :string
#  state           :string
#  country         :string
#  addresable_id   :integer
#  addresable_type :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

message = 'Please complete field'

RSpec.describe Address, type: :model do
  it { should validate_presence_of(:suburb).with_message(message) }
  it { should validate_presence_of(:line_one).with_message(message) }
  it { should validate_presence_of(:post_code).with_message(message) }
  it { should validate_presence_of(:state).with_message(message) }
  it { should define_enum_for(:state) }
  it { should define_enum_for(:country) }

  describe 'one_line_address' do
    let(:address) {FactoryGirl.create(:address, state: 2, country: 1)}
    it 'should return false for student' do
      expect(address.one_line_address).to eq "#{address.line_one}, #{address.line_two}, #{address.suburb}, #{address.state.try(:humanize).try(:titleize)}, #{address.post_code}, #{address.country.try(:humanize).try(:titleize)}"
    end
  end
end
