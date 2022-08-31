class TutorSchedulePolicy < ApplicationPolicy

  def create?
    @user.tutor? && @user.tutor_profile.private_tutor
  end

  def new?
    create?
  end

  def edit?
    create?
  end

  def update?
    create?
  end

  def destroy?
    create?
  end
end