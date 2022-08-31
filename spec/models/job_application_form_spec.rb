require 'rails_helper'

RSpec.describe JobApplicationForm, type: :model do
  subject(:job_application_form) { FactoryGirl.build(:job_application_form) }

  it 'has valid :job_application_form factory' do
    expect(job_application_form).to be_valid
  end

  it { expect(job_application_form).to have_many :job_applications }
  it { expect(job_application_form).to have_many :application_questions }

  it { should validate_presence_of :title }
end
