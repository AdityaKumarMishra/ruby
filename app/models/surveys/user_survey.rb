# == Schema Information
#
# Table name: user_surveys
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  survey_id   :integer
#  is_submited :boolean
#

class Surveys::UserSurvey < ApplicationRecord
  belongs_to :user
  belongs_to :survey, :class_name => 'Surveys::Survey'

  scope :for_user, -> (user) { where('user_id' => user.id)}
end
