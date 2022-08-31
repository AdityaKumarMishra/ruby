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

class FaqPage < ApplicationRecord
  belongs_to :faq_topic

  def type
    faq_topic.faq_type.to_sym
  end

  def map_faq_type
  	if faq_topic.faq_type.to_sym==:gamsat
      new_faq_type="gamsat-preparation-courses"
    elsif faq_topic.faq_type.to_sym==:umat
      new_faq_type="umat-preparation-courses"
    else
      new_faq_type=faq_topic.faq_type.to_sym
    end
    return new_faq_type
  end

end
