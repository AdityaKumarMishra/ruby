class Watched < ApplicationRecord
  belongs_to :user
  belongs_to :vod
end
