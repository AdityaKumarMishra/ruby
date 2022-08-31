require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ContactHelper. For example:
#
# describe ContactHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ContactHelper, type: :helper do
  describe '#fetch_contact_team_url' do
    it 'should return gamsat team path' do
      product_line = "gamsat"
      expect(fetch_contact_team_url(product_line)).to eq('/gamsat-preparation-courses/team')
    end

    it 'should return umat team path' do
      product_line = "umat"
      expect(fetch_contact_team_url(product_line)).to eq('/umat-preparation-courses/team')
    end

    it 'should return hsc team path' do
      product_line = "hsc"
      expect(fetch_contact_team_url(product_line)).to eq('/hsc/team')
    end

    it 'should return vce team path' do
      product_line = "vce"
      expect(fetch_contact_team_url(product_line)).to eq('/vce/team')
    end

    it 'should return team path without product line' do
      product_line = nil
      expect(fetch_contact_team_url(product_line)).to eq('/gamsat-preparation-courses/team')
    end
  end
end
