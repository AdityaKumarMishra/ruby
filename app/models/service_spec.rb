# == Schema Information
#
# Table name: service_specs
#
#  id              :integer          not null, primary key
#  invoice_spec_id :integer
#  exam_id         :integer
#  essay_id        :integer
#  mcq_id          :integer
#  apoitment_id    :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class ServiceSpec < ApplicationRecord
  belongs_to :invoice_spec
  belongs_to :additional_exam, :class_name => 'Exam', :foreign_key => 'exam_id', optional: true
  belongs_to :additional_essay, :class_name => 'Essay', :foreign_key => 'essay_id', optional: true
  belongs_to :additional_mcq, :class_name => 'Mcq', :foreign_key => 'mcq_id', optional: true
  belongs_to :additional_apoitment, :class_name => 'Apoitment', :foreign_key => 'apoitment_id', optional: true

  scope :active, -> {joins(:invoice_spec).where('invoice_spec.stopping_date > NOW() AND invoice_spec.expiration_date  > NOW() ')}

  def is_active
    invoice_spec.stopping_date > DateTime.current && invoice_spec.expiration_date > DateTime.current
  end
  alias_method :active?, :is_active
end
