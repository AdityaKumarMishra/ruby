# == Schema Information
#
# Table name: subjects
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  slug        :string
#  course_id   :integer
#

require 'rails_helper'

RSpec.describe Subject, type: :model do
  subject(:subject) { FactoryGirl.build(:subject) }

  it 'has valid :subject factory' do
    expect(subject).to be_valid
  end

  it { expect(subject).to have_many :user_subjects }
  it { expect(subject).to have_many :users }
  it { expect(subject).to have_many :student_questions }

  it { expect(subject).to validate_presence_of :title }
  it { expect(subject).to validate_presence_of :description }

  it { expect(subject).to validate_length_of(:title).is_at_most(100) }
  it { expect(subject).to validate_length_of(:description).is_at_most(500) }

  it { expect(subject).to validate_uniqueness_of(:slug) }

  # it { should validate_presence_of(:course_version)}
end
