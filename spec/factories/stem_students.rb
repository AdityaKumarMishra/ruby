# == Schema Information
#
# Table name: stem_students
#
#  id          :integer          not null, primary key
#  time_left   :integer
#  description :text
#  title       :string
#  mcqs        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#  mcq_stem_id :integer
#  tag_id      :integer
#  subject_id  :integer
#

FactoryGirl.define do
  factory :stem_student do
    user nil
mcq_stems nil
time_left 1
description "MyText"
title "MyString"
mcqs ""
  end

end
