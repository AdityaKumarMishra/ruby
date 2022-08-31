#
# Table name: job_descriptions
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

RSpec.describe JobDescription, type: :model do
  let(:job_description) { FactoryGirl.build(:job_description) }

  it 'has valid :resume factory' do
    expect(job_description).to be_valid
  end

  it { expect(job_description).to belong_to :job_application_form }
end
