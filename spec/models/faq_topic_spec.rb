# == Schema Information
#
# Table name: faq_topics
#
#  id         :integer          not null, primary key
#  faq_type   :integer
#  code       :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  slug       :string           not null
#

require 'rails_helper'

RSpec.describe FaqTopic, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
