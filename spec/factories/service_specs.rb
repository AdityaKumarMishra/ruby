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

FactoryGirl.define do
  factory :service_spec do
    invoice_spec nil
exam nil
essay nil
mcq nil
apoitment nil
  end

end
