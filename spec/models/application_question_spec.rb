require 'rails_helper'

RSpec.describe ApplicationQuestion, type: :model do
  subject(:application_question) { FactoryGirl.build(:application_question) }

  it 'has valid :question factory' do
    expect(application_question).to be_valid
  end

  it { expect(application_question).to belong_to :job_application_form }
  it { expect(application_question).to have_many :answer_options }
  it { expect(application_question).to have_one :application_answer }

  it { should validate_presence_of :content }
end
