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

class FaqTopic < ApplicationRecord
  extend FriendlyId
  enum faq_type: [:gamsat, :umat, :vce, :hsc]
  has_one :faq_page, dependent: :destroy

  friendly_id :title, use: :slugged

  validates_presence_of :title, :slug
  validates_uniqueness_of :slug

  def self.codes
    {
      :understanding_gamsat => 'understanding-gamsat',
      :preparing_gamsat => 'preparing-gamsat',
      :about_gradready => 'about-gradready',
      :enrolment_payment => 'enrolment-payment',
      :non_science_background => 'non-science-background',
      :postgraduate_medical_school_admissions => 'postgraduate-medical-school-admissions',
      :und_umat => 'und_umat',
      :eligibility => 'eligibility',
      :preparation => 'preparation',
      :umatready => 'umatready',
      :undergraduate => 'undergraduate',
      :enrolment => 'enrolment',
      :und_vce => 'und_vce',
      :vce_ready => 'vce_ready',
      :und_hsc => 'und_hsc',
      :hsc_ready => 'hsc_ready'
    }
  end

  def self.for_type type
    raise 'Faq type not Found' if !FaqTopic.faq_types.has_key? type
    eval "FaqTopic.#{type}"
  end

  def self.for_code code
    # raise 'Faq Topic not Found' if !FaqTopic.codes.has_value? code
    FaqTopic.find_by(code: code)
  end

  def to_s
    title
  end
end
