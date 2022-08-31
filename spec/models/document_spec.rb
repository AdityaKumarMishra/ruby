# == Schema Information
#
# Table name: documents
#
#  id                       :integer
#  accessible               :boolean
#  allow_dummy              :datetime
#  only_dummy               :datetime
#  user_id                  :integer
#  attachment_file_name     :string
#  attachment_content_type  :string
#  attachment_file_size     :integer
#  attachment_updated_at    :datetime
#  created_at               :datetime
#  updated_at               :datetime
#

require 'rails_helper'

message = 'Please include a document'

RSpec.describe Document, type: :model do
  let(:document) { FactoryGirl.build(:document) }

  it 'has valid :document factory' do
    expect(document).to be_valid
  end

  it { should belong_to(:user) }
  it { should have_many(:taggings) }
  it { should have_many(:tags).through(:taggings) }
  it { should have_many(:access_documents).dependent(:destroy) }
  it { should have_many(:users).through(:access_documents) }
  it { should validate_presence_of(:attachment).with_message(message) }
  it { should have_many(:tickets) }

  describe '#name_human' do
    it 'should return document human name' do
      document = FactoryGirl.create(:document)
      expect(document.name_human).to eq('Document')
    end
  end

  describe '#title' do
    it 'should return document title' do
      document = FactoryGirl.create(:document)
      expect(document.title).to eq('Test Document.Pdf')
    end
  end

end
