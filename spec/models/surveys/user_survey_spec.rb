# == Schema Information
#
# Table name: user_surveys
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  survey_id   :integer
#  is_submited :boolean
#

require 'rails_helper'

RSpec.describe Surveys::UserSurvey, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
