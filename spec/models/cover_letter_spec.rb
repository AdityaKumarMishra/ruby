#
# Table name: cover_letters
#
#  id                  :integer          not null, primary key
#  job_application_id    :integer
#  document_file_name  :string
#  document_content_type :string
#  document_file_size  :integer
#  document_updated_at :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'rails_helper'

message = 'Please include a cover letter'

RSpec.describe CoverLetter, type: :cover_letter do
  let(:cover_letter) { FactoryGirl.build(:cover_letter) }

  it 'has valid :resume factory' do
    expect(cover_letter).to be_valid
  end

  it { expect(cover_letter).to belong_to :job_application }
  it { should validate_presence_of(:document).with_message(message) }
end
