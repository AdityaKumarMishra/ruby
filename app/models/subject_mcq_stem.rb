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

class SubjectMcqStem < ApplicationRecord
  belongs_to :subject
  belongs_to :mcq_stem
end
