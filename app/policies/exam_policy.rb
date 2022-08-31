class ExamPolicy < ApplicationPolicy
  class Scope < Scope
    def initialize(user, exam_class)
      @user = user
      @exam_class = exam_class
    end

    def resolve
      if @user.student?
        @exam_class.where(publish: true)
      else
        @exam_class.all
      end
    end
  end

  def initialize(user, exam)
    @user = user
    @exam = exam
  end

  def show?
    @exam.publish? || !@user.student?
  end

  def new?
    show?
  end

  def create?
    !@user.student?
  end

  def update?
    !user.student? && !@exam.publish?
  end

  def destroy?
    !user.student? && !@exam.publish?
  end
end
