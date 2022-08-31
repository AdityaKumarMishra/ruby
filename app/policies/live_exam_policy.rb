class LiveExamPolicy < ApplicationPolicy

  def initialize(user, exam)
    @user = user
    @exam = exam
  end

  def index?
    @user.student?
  end

  def create?
    @user.student?
  end

  def destroy?
    !@user.student?
  end
end
