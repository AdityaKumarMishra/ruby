class AttemptedMcq < ApplicationRecord
	belongs_to :mcq
	belongs_to :attemptable, polymorphic: true
end
