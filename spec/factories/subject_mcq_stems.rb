# == Schema Information
#
# Table name: subject_mcq_stems
#
#  id          :integer          not null, primary key
#  subject_id  :integer
#  mcq_stem_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :subject_mcq_stem do
    subject nil
mcq_stem nil
  end

end
