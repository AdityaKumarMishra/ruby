require 'rails_helper'

RSpec.describe ApplicationAnswer, type: :model do

  subject(:application_answer) { FactoryGirl.build(:application_answer) }

  it 'has valid :answer factory' do
    expect(application_answer).to be_valid
  end

  it { expect(application_answer).to belong_to :job_application }
  it { expect(application_answer).to belong_to :application_question }

end
