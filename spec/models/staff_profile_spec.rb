require 'rails_helper'

RSpec.describe StaffProfile, type: :model do
  it { should have_many(:course_staffs).dependent(:destroy) }
end
