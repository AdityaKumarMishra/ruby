# == Schema Information
#
# Table name: essays
#
#  id              :integer          not null, primary key
#  title           :string
#  question        :text
#  date_added      :datetime
#  expiration_date :datetime
#  tutor_id        :integer
#  student_id      :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  exam_id         :integer
#  slug            :string
#

require 'rails_helper'

RSpec.describe Essay, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
