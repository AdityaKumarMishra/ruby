=begin
require 'rails_helper'

describe VodPolicy do
  let(:superadmin) { FactoryGirl.create :user, :superadmin }
  let(:admin) { FactoryGirl.create :user, :admin }
  let(:manager) { FactoryGirl.create :user, :manager }
  let(:tutor) { FactoryGirl.create :user, :tutor }
  let(:student) { FactoryGirl.create :user, :student }
  let(:video) { FactoryGirl.create :vod }
  subject { described_class }

  context 'when superadmin and admin' do
    permissions '.scope' do
      it 'can view all' do
        expect(VodPolicy::Scope.new(superadmin, Vod).resolve).to eq [video]
        expect(VodPolicy::Scope.new(admin, Vod).resolve).to eq [video]
      end
    end

    permissions :show? do
      it 'can view a view' do
        expect(subject).to permit(admin, video)
        expect(subject).to permit(superadmin, video)
      end
    end

    permissions :create? do
      it 'can upload video' do
        expect(subject).to permit(admin, video)
        expect(subject).to permit(superadmin, video)
      end
    end

    permissions :update? do
      it 'can update a video' do
        expect(subject).to permit(admin, video)
        expect(subject).to permit(superadmin, video)
      end
    end

    permissions :destroy? do
      it 'can delete a video' do
        expect(subject).to permit(admin, video)
        expect(subject).to permit(superadmin, video)
      end
    end
  end

  context 'when tutor, manager' do
    permissions '.scope' do
      it 'can view all videos' do
        expect(VodPolicy::Scope.new(manager, Vod).resolve).to eq [video]
        expect(VodPolicy::Scope.new(tutor, Vod).resolve).to eq [video]
      end

      permissions :show? do
        it 'can view any videos' do
          expect(subject).to permit(tutor, video)
          expect(subject).to permit(manager, video)
        end
      end
    end
  end

  context 'when student' do
    permissions '.scope' do
      it 'student can view only enrolled videos' do
        expect(VodPolicy::Scope.new(student, Vod).resolve).to eq []
      end
    end

    permissions :show? do
      it 'cannot see random video unless its enrolled' do
        expect(subject).not_to permit(student, video)
      end
    end

    permissions :edit? do
      it 'can not edit video' do
        expect(subject).not_to permit(student, video)
      end
    end

    permissions :create? do
      it 'can not create video' do
        expect(subject).not_to permit(student, video)
      end
    end

    permissions :update? do
      it 'can not update video' do
        expect(subject).not_to permit(student, video)
      end
    end
    permissions :destroy? do
      it 'can not delete video' do
        expect(subject).not_to permit(student, video)
      end
    end

  end
end
=end