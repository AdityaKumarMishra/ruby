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

require 'rails_helper'

RSpec.describe StemStudent, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
