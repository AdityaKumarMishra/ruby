# == Schema Information
#
# Table name: tutor_answers
#
#  id             :integer          not null, primary key
#  answer         :text
#  date_published :datetime
#  published      :boolean
#  user_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'rails_helper'

RSpec.describe TutorAnswer, type: :model do
  subject(:tutor_answer) { FactoryGirl.build(:tutor_answer, :with_user) }

  it 'has valid :tutor_answer factory' do
    expect(tutor_answer).to be_valid
  end

  it { expect(tutor_answer).to belong_to :user }
  it { expect(tutor_answer).to have_many :student_questions }

  it { expect(tutor_answer).to validate_presence_of :date_published }
  it { expect(tutor_answer).to validate_presence_of :user_id }
  it { expect(tutor_answer).to validate_presence_of :answer }

  it { expect(tutor_answer).to validate_length_of(:answer).is_at_most(500) }
end
