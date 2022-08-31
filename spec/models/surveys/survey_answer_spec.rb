# == Schema Information
#
# Table name: survey_answers
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  survey_question_id :integer
#  answer             :text
#  rating             :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'rails_helper'

RSpec.describe Surveys::SurveyAnswer, type: :model do

  it { should belong_to :user }
  it { should belong_to :survey_question }

  it { should validate_presence_of :user_id }
  it { should validate_presence_of :survey_question_id }
  it { should validate_presence_of :answer }
end
