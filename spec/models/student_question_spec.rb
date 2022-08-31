# == Schema Information
#
# Table name: student_questions
#
#  id              :integer          not null, primary key
#  question        :text
#  date_published  :datetime
#  published       :boolean
#  user_id         :integer
#  tutor_answer_id :integer
#  subject_id      :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  slug            :string
#

require 'rails_helper'

RSpec.describe StudentQuestion, type: :model do
  subject(:student_question) { FactoryGirl.create(:student_question, :with_stack) }

  it 'has valid :student_question factory' do
    expect(student_question).to be_valid
  end

  it { expect(student_question).to belong_to :user }
  it { expect(student_question).to belong_to :tutor_answer }
  it { expect(student_question).to belong_to :subject }

  it { expect(student_question).to validate_presence_of :question }
  it { expect(student_question).to validate_presence_of :date_published }
  it { expect(student_question).to validate_presence_of :user_id }
  it { expect(student_question).to validate_presence_of :subject_id }
end
