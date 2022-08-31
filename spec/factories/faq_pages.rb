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

FactoryGirl.define do
  factory :faq_page do
    faq_topic
    content "MyText"
  end

end
