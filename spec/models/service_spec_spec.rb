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

require 'rails_helper'

RSpec.describe ServiceSpec, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
