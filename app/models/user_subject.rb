# == Schema Information
#
# Table name: user_subjects
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  active_subject_id :integer
#

class UserSubject < ApplicationRecord
  belongs_to :user
  belongs_to :subject, :class_name => 'ActiveSubject', :foreign_key => 'active_subject_id'

  validates_presence_of :user_id, :active_subject_id
end
