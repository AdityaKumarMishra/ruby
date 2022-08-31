# == Schema Information
#
# Table name: survey_questions
#
#  id         :integer          not null, primary key
#  survey_id  :integer
#  question   :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Surveys::SurveyQuestion, type: :model do

  it { should belong_to :survey }

  it { should validate_presence_of :survey_id }
  it { should validate_presence_of :question }
end
