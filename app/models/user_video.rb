class UserVideo < ApplicationRecord
	belongs_to :mcq
	belongs_to :mcq_video
	belongs_to :user
end
