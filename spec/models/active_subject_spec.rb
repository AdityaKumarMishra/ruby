# == Schema Information
#
# Table name: active_subjects
#
#  id                :integer          not null, primary key
#  subject_id        :integer
#  course_version_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'rails_helper'

RSpec.describe ActiveSubject, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
