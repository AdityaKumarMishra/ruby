require 'rails_helper'

describe StaffProfilePolicy do


  let(:admin) { FactoryGirl.create :user, :admin }
  let(:superadmin) { FactoryGirl.create :user, :superadmin }
  let(:manager) { FactoryGirl.create :user, :manager }
  let(:tutor) { FactoryGirl.create :user, :tutor }
  let(:student) { FactoryGirl.create :user, :student }

  let(:staff1) {FactoryGirl.create :staff_profile, staff: :tutor}
  subject { described_class }
  context 'when superadmin' do
    permissions '.scope' do
      it 'can see all staff_profiles' do
        expect(StaffProfilePolicy::Scope.new(superadmin, StaffProfile).resolve).to eq StaffProfile.all.includes(:staff).where(users: {role: 1}).order("first_name ASC")
      end
    end

  end

  context 'when admin' do
    permissions '.scope' do
      it 'can see all staff_profiles' do
        expect(StaffProfilePolicy::Scope.new(admin, StaffProfile).resolve).to eq StaffProfile.includes(:staff).where(users: {role: 1}).order("first_name ASC")
      end
    end

  end

  context 'when manager' do
    permissions '.scope' do
      it 'can see all staff_profiles' do
        expect(StaffProfilePolicy::Scope.new(manager, StaffProfile).resolve).to eq StaffProfile.includes(:staff).where(users: {role: 1}).order("first_name ASC")
      end
    end

  end

  context 'when tutor' do
    permissions '.scope' do
      it 'can see all staff_profiles' do
        expect(StaffProfilePolicy::Scope.new(tutor, StaffProfile).resolve).to eq StaffProfile.includes(:staff).where(users: {role: 1}).order("first_name ASC")
      end
    end

  end

  context 'when superadmin' do
    permissions '.scope' do
      it 'can see no staff_profiles' do
        expect(StaffProfilePolicy::Scope.new(student, StaffProfile).resolve).to eq []
      end
    end

  end
end
