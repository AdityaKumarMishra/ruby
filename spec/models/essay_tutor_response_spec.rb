# == Schema Information
#
# Table name: essay_tutor_responses
#
#  id                :integer          not null, primary key
#  response          :text
#  rate              :decimal(10, 2)
#  essay_response_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'rails_helper'

RSpec.describe EssayTutorResponse, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
