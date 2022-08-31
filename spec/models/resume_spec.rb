#
# Table name: resumes
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

message = 'Please include a resume'

RSpec.describe Resume, type: :model do
  let(:resume) { FactoryGirl.build(:resume) }

  it 'has valid :resume factory' do
    expect(resume).to be_valid
  end

  it { expect(resume).to belong_to :job_application }
  it { should validate_presence_of(:document).with_message(message) }

end
