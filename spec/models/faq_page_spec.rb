# == Schema Information
#
# Table name: faq_pages
#
#  id           :integer          not null, primary key
#  faq_topic_id :integer
#  content      :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe FaqPage, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
