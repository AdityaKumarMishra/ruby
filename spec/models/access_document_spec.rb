# == Schema Information
#
# Table name: access_documents
#
#  id                     :integer
#  last_accessed          :datetime
#  document_id            :integer
#  user_id                :integer
#  created_at             :datetime
#  updated_at             :datetime
#

require 'rails_helper'

RSpec.describe AccessDocument, type: :model do
  let(:access_document) { FactoryGirl.build(:access_document) }

  it 'has valid :access_document factory' do
    expect(access_document).to be_valid
  end

  it { expect(access_document).to belong_to :user }
  it { expect(access_document).to belong_to :document }
end
