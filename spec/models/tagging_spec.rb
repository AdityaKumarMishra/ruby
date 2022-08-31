require 'rails_helper'

RSpec.describe Tagging, type: :model do
  let(:taggable_content) { FactoryGirl.create :vod }
  let(:tagging) { FactoryGirl.create(:tagging, taggable: taggable_content) }
end
