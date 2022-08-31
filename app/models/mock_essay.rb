class MockEssay < ApplicationRecord
  belongs_to :mock_exam_essay, optional: true
  has_one :mock_essay_feedback, dependent: :destroy
  has_attached_file :essay, :restricted_characters => /[&$+,\/:;=?@<>\[\]\{\}\|\\\^~%]/

  validates_attachment :essay, presence: true, content_type: { content_type: ["application/pdf", "application/vnd.openxmlformats-officedocument.wordprocessingml.document", 'application/msword'] }, size: { in: 0..2.megabytes }


  def title
    last_index = essay_file_name.rindex(".")
    essay_file_name[0...last_index].titleize
  end
end
