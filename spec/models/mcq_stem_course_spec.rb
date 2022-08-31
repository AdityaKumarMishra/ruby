# == Schema Information
#
# Table name: mcq_stem_courses
#
#  id          :integer          not null, primary key
#  mcq_stem_id :integer
#  course_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe McqStemCourse, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
