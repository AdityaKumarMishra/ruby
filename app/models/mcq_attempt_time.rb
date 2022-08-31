class McqAttemptTime < ApplicationRecord
  belongs_to :sectionable, polymorphic: true
end
