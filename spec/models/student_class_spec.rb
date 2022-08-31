# == Schema Information
#
# Table name: student_classes
#
#  id                :integer          not null, primary key
#  name              :string
#  size              :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  course_version_id :integer
#  active_subject_id :integer
#  item_coverd       :text
#

require 'rails_helper'

RSpec.describe StudentClass, type: :model do

  it 'should have a valid factory' do
    expect(FactoryGirl.build(:student_class)).to be_valid
  end

  it {should belong_to(:active_subject)}
  it {should have_one(:subject)}
  it {should have_and_belong_to_many(:tutors)}
  it {should have_and_belong_to_many(:students)}
  it {should have_many(:student_class_sessions)}

  it {should validate_presence_of(:size)}
  it {should validate_presence_of(:name)}

end
