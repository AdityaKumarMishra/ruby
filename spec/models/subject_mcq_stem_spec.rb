# == Schema Information
#
# Table name: subject_mcq_stems
#
#  id          :integer          not null, primary key
#  subject_id  :integer
#  mcq_stem_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe SubjectMcqStem, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
