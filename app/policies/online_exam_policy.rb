class OnlineExamPolicy < ApplicationPolicy
  class Scope < Scope
    def initialize(user, online_exam_class)
      @user = user
      @online_exam_class = online_exam_class
    end

    def resolve
      if @user.student?
        feature_name = @online_exam_class.name.eql?('DiagnosticTest') ? 'Diagnostics' : 'ExamFeature'
        user_tag_ids = @user.current_feature_tags(feature_name).collect{|t| t.id}
        qty = @user.online_exam_feature.sum(:qty)
        @online_exam_class.eager_load(:tags).where(published: true).where('tags.id IN (?)', user_tag_ids)
      else
        @online_exam_class.all
      end
    end
  end

  def initialize(user, online_exam)
    @user = user
    @online_exam = online_exam
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

  def duplicate?
    @user.admin? || @user.superadmin?
  end

  def archived_online_exams?
    !@user.student?
  end
end
