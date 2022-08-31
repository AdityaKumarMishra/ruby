class OnlineMockExamPolicy < ApplicationPolicy
  class Scope < Scope
    def initialize(user, online_mock_exam_class)
      @user = user
      @online_mock_exam_class = online_mock_exam_class
    end

    def resolve
      if @user.student?
        feature_name = 'OnlineMockExam'
        user_tag_ids = @user.current_feature_tags(feature_name).collect{|t| t.id}
        @online_mock_exam_class.eager_load(:tags).where('tags.id IN (?)', user_tag_ids)
      else
        @online_mock_exam_class.all
      end
    end
  end

  def initialize(user, online_mock_exam)
    @user = user
    @online_mock_exam = online_mock_exam
  end

  def index?
    !@user.student?
  end

  def show?
    !@user.student?
  end

  def new?
    show?
  end

  def create?
    !@user.student?
  end

  def update?
    !@user.student?
  end

  def destroy?
    @user.admin? || @user.superadmin?
  end

  def change_lock?
    @user.admin? || @user.superadmin?
  end

  def archived_online_mock_exams?
    !@user.student?
  end
end
