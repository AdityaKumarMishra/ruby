#
# Table name: application_attachments
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

RSpec.describe ApplicationAttachment, type: :model do
  let(:application_attachment) { FactoryGirl.build(:application_attachment) }

  it 'has valid :resume factory' do
    expect(application_attachment).to be_valid
  end

  it { expect(application_attachment).to belong_to :job_application }
end
