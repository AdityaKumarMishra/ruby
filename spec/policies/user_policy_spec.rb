require 'rails_helper'

describe UserPolicy do
  let(:admin) { FactoryGirl.create :user, :admin }
  let(:superadmin) { FactoryGirl.create :user, :superadmin }
  let(:manager) { FactoryGirl.create :user, :manager }
  let(:tutor) { FactoryGirl.create :user, :tutor }
  let(:student) { FactoryGirl.create :user, :student }

  subject { described_class }
  context 'when superadmin' do
    permissions '.scope' do
      it 'can see all users' do
        expect(UserPolicy::Scope.new(superadmin, User).resolve).to eq User.all
      end
    end

    permissions :show? do
      it 'can view student' do
        expect(subject).to permit(superadmin, student)
      end

      it 'can view tutor' do
        expect(subject).to permit(superadmin, tutor)
      end

      it 'can view manager' do
        expect(subject).to permit(superadmin, manager)
      end

      it 'can view admin' do
        expect(subject).to permit(superadmin, admin)
      end

      it 'can view superadmin' do
        expect(subject).to permit(superadmin, superadmin)
      end
    end

    permissions :create? do
      it 'can create student' do
        expect(subject).to permit(superadmin, User.new(role: :student))
      end

      it 'can create tutor' do
        expect(subject).to permit(superadmin, User.new(role: :tutor))
      end

      it 'can create manager' do
        expect(subject).to permit(superadmin, User.new(role: :manager))
      end

      it 'can create admin' do
        expect(subject).to permit(superadmin, User.new(role: :admin))
      end

      it 'can create superadmin' do
        expect(subject).to permit(superadmin, User.new(role: :superadmin))
      end
    end

    permissions :update? do
      it 'can update student' do
        expect(subject).to permit(superadmin, student)
      end

      it 'can update tutor' do
        expect(subject).to permit(superadmin, tutor)
      end

      it 'can update manager' do
        expect(subject).to permit(superadmin, manager)
      end

      it 'can update admin' do
        expect(subject).to permit(superadmin, admin)
      end

      it 'can update superadmin' do
        expect(subject).to permit(superadmin, superadmin)
      end
    end

    permissions :destroy? do
      it 'can destroy student' do
        expect(subject).to permit(superadmin, student)
      end

      it 'can destroy tutor' do
        expect(subject).to permit(superadmin, tutor)
      end

      it 'can destroy manager' do
        expect(subject).to permit(superadmin, manager)
      end

      it 'can destroy admin' do
        expect(subject).to permit(superadmin, admin)
      end

      it 'can destroy superadmin' do
        expect(subject).to permit(superadmin, superadmin)
      end
    end
  end

  context 'when admin' do
    # permissions '.scope' do
    #   it 'can see all users without superadmin and admin' do
    #     expect(UserPolicy::Scope.new(admin, User).resolve).to eq User.where.not(role: ['superadmin', 'admin'])
    #   end
    # end
    permissions :show? do
      it 'cannot view superadmins' do
        expect(subject).not_to permit(admin, superadmin)
      end
      let(:admin_2) { FactoryGirl.create :user, :admin }
      it 'can view other admins' do
        expect(subject).to permit(admin, admin_2)
      end

      it 'can view managers' do
        expect(subject).to permit(admin, manager)
      end

      it 'can view tutors' do
        expect(subject).to permit(admin, tutor)
      end

      it 'can view students' do
        expect(subject).to permit(admin, student)
      end
    end

    permissions :create? do
      it 'cannot create superadmins' do
        expect(subject).not_to permit(admin, User.new(role: :superadmin))
      end

      it 'can create admins' do
        expect(subject).to permit(admin, User.new(role: :admin))
      end

      it 'can create managers' do
        expect(subject).to permit(admin, User.new(role: :manager))
      end

      it 'can create tutors' do
        expect(subject).to permit(admin, User.new(role: :tutor))
      end

      it 'can create students' do
        expect(subject).to permit(admin, User.new(role: :student))
      end
    end

    permissions :update? do
      it 'cannot update superadmins' do
        expect(subject).not_to permit(admin, superadmin)
      end

      let(:admin_2) { FactoryGirl.create :user, :admin }
      it 'can update admins' do
        expect(subject).to permit(admin, admin_2)
        expect(subject).to permit(admin, admin)
      end

      it 'can update managers' do
        expect(subject).to permit(admin, manager)
      end

      it 'can update tutors' do
        expect(subject).to permit(admin, tutor)
      end

      it 'can update students' do
        expect(subject).to permit(admin, student)
      end
    end

    permissions :destroy? do
      # same as update
    end
  end

  context 'when manager' do
    # permissions '.scope' do
    #   it ' shows students' do
    #     expect(UserPolicy::Scope.new(manager, User).resolve).to eq User.where(role: 'student')
    #   end
    #   it ' shows tutors' do
    #     expect(UserPolicy::Scope.new(manager, User).resolve).to eq User.where(role: 'tutor')
    #   end
    # end
    permissions :show? do
      it 'cannot view superadmins' do
        expect(subject).not_to permit(manager, superadmin)
      end
      it 'cannot view admins' do
        expect(subject).not_to permit(manager, admin)
      end

      let(:manager_2) { FactoryGirl.create :user, :manager }
      it 'can view managers' do
        expect(subject).to permit(manager, manager_2)
      end

      it 'can view self' do
        expect(subject).to permit(manager, manager)
      end

      it 'can view tutors' do
        expect(subject).to permit(manager, tutor)
      end

      it 'can view students' do
        expect(subject).to permit(manager, student)
      end
    end

    permissions :create? do
      it 'cannot create superadmins' do
        expect(subject).not_to permit(manager, User.new(role: :superadmin))
      end

      it 'cannot create admin' do
        expect(subject).not_to permit(manager, User.new(role: :admin))
      end

      it 'can create manager' do
        expect(subject).to permit(manager, User.new(role: :manager))
      end

      it 'can create tutor' do
        expect(subject).to permit(manager, User.new(role: :tutor))
      end

      it 'can create student' do
        expect(subject).to permit(manager, User.new(role: :student))
      end
    end

    permissions :update? do
      it 'cannot update superadmin' do
        expect(subject).not_to permit(admin, superadmin)
      end

      it 'cannot update admin' do
        expect(subject).not_to permit(manager, admin)
      end

      it 'can update self' do
        expect(subject).to permit(manager, manager)
      end
      let(:manager_2) { FactoryGirl.create :user, :manager }

      it 'can update other manager' do
        expect(subject).to permit(manager, manager_2)
      end
      it 'can update tutor' do
        expect(subject).to permit(manager, tutor)
      end

      it 'can update student' do
        expect(subject).to permit(manager, student)
      end
    end

    permissions :destroy? do
      # same as update
    end
  end

  context 'when tutor' do
    permissions '.scope' do
    end
    let(:tutor_2) { FactoryGirl.create :user, :tutor }
    permissions :show? do
      it 'cannot view superadmins' do
        expect(subject).not_to permit(tutor, superadmin)
      end

      it 'cannot view admins' do
        expect(subject).not_to permit(tutor, admin)
      end

      it 'cannot view managers' do
        expect(subject).not_to permit(tutor, manager)
      end

      it 'cannot view other tutors' do
        expect(subject).not_to permit(tutor, tutor_2)
      end

      it 'can view self' do
        expect(subject).to permit(tutor, tutor)
      end

      it 'can view students' do
        expect(subject).to permit(tutor, student)
      end
    end

    permissions :create? do
      it 'cannot create superadmins' do
        expect(subject).not_to permit(tutor, User.new(role: :superadmin))
      end

      it 'cannot create admin' do
        expect(subject).not_to permit(tutor, User.new(role: :admin))
      end

      it 'cannot create manager' do
        expect(subject).not_to permit(tutor, User.new(role: :manager))
      end

      it 'cannot create tutor' do
        expect(subject).not_to permit(tutor, User.new(role: :tutor))
      end

      it 'cannot create student' do
        expect(subject).not_to permit(tutor, User.new(role: :student))
      end
    end

    permissions :update? do
      it 'cannot update superadmin' do
        expect(subject).not_to permit(tutor, superadmin)
      end

      it 'cannot update admin' do
        expect(subject).not_to permit(tutor, admin)
      end

      it 'cannot update manager' do
        expect(subject).not_to permit(tutor, manager)
      end

      it 'cannot update tutor' do
        expect(subject).not_to permit(tutor, tutor_2)
      end

      it 'can update self' do
        expect(subject).to permit(tutor, tutor)
      end

      it 'cannot update student' do
        expect(subject).not_to permit(tutor, student)
      end
    end

    permissions :destroy? do
      # same as update?
    end
  end

  context 'when student' do
    permissions '.scope' do
    end
    let(:student_2) { FactoryGirl.create :user, :student }
    permissions :show? do
      it 'cannot view superadmins' do
        expect(subject).not_to permit(student, superadmin)
      end

      it 'cannot view admins' do
        expect(subject).not_to permit(student, admin)
      end

      it 'cannot view managers' do
        expect(subject).not_to permit(student, manager)
      end

      it 'cannot view tutors' do
        expect(subject).not_to permit(student, tutor)
      end

      it 'cannot view other students' do
        expect(subject).not_to permit(student, student_2)
      end

      it 'can view self' do
        expect(subject).to permit(student, student)
      end
    end

    permissions :create? do
      it 'cannot create superadmins' do
        expect(subject).not_to permit(student, User.new(role: :superadmin))
      end

      it 'cannot create admins' do
        expect(subject).not_to permit(student, User.new(role: :admin))
      end

      it 'cannot create managers' do
        expect(subject).not_to permit(student, User.new(role: :manager))
      end

      it 'cannot create tutors' do
        expect(subject).not_to permit(student, User.new(role: :tutor))
      end

      it 'cannot create students' do
        expect(subject).not_to permit(student, User.new(role: :student))
      end
    end

    permissions :update? do
      it 'cannot update superadmins' do
        expect(subject).not_to permit(student, superadmin)
      end

      it 'cannot update admins' do
        expect(subject).not_to permit(student, admin)
      end

      it 'cannot update managers' do
        expect(subject).not_to permit(student, manager)
      end

      it 'cannot update tutors' do
        expect(subject).not_to permit(student, tutor)
      end

      it 'cannot update other students' do
        expect(subject).not_to permit(student, student_2)
      end

      it 'can update self' do
        expect(subject).to permit(student, student)
      end
    end

    permissions :destroy? do
      # same as update?
    end
  end
end
