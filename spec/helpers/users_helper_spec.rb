require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the UsersHelper. For example:
#
# describe UsersHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe UsersHelper, type: :helper do
  subject(:user) { FactoryGirl.build(:user, :student, status: 0) }
  describe "#changed_status" do
    it 'should return Deactivated' do
      expect(changed_status(user)).to eq('deactivated')
    end
  end

  describe "#changed_status_link_text" do
    it 'should return Deactivate' do
      expect(changed_status_link_text(user)).to eq('Deactivate')
    end
  end
end
