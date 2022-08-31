require 'rails_helper'

RSpec.describe OrderPolicy do

  let(:admin) { FactoryGirl.create :user, :admin }
  let(:superadmin) { FactoryGirl.create :user, :superadmin }
  let(:manager) { FactoryGirl.create :user, :manager }
  let(:student) { FactoryGirl.create :user, :student }
  let(:order1) { FactoryGirl.create :order, status: 1, user_id: admin.id}
  let(:order2) { FactoryGirl.create :order, status: 1, user_id: superadmin.id}
  let(:order3) { FactoryGirl.create :order, status: 1, user_id: manager.id}
  let(:order4) { FactoryGirl.create :order, status: 1, user_id: student.id}

  subject { described_class }

  permissions :redact_order? do
    it 'can redact order' do
      expect(subject).to permit(admin, order1)
      expect(subject).to permit(superadmin, order2)
      expect(subject).to permit(manager, order3)
      expect(subject).to permit(student, order4)
    end
  end

  permissions ".scope" do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :show? do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :create? do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :update? do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :destroy? do
    pending "add some examples to (or delete) #{__FILE__}"
  end
end
