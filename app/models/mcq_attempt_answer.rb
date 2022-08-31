class McqAttemptAnswer < ApplicationRecord
	belongs_to :mcq_attempt
	belongs_to :mcq_answer
end
