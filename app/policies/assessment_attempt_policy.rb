class AssessmentAttemptPolicy < ApplicationPolicy
  class Scope < Scope
    def initialize(user, assessment_attempt_class)
      @user = user
      @assessment_attempt_class = assessment_attempt_class
    end

    def resolve
      fail Pundit::NotAuthorizedError unless @user.student?
      @user.assessment_attempts.where(course_id: @user.active_course.try(:id))
    end
  end

  def initialize(user, assessment_attempt)
    @user = user
    @assessment_attempt = assessment_attempt
  end

  def show?
    @assessment_attempt.user == @user
  end

  def new?
    @user.student?
  end

  def create?
    @user.student? && @assessment_attempt.assessable.published?
  end

  def destroy?
    show?
  end

  def online_exams_index?
    if @user.student?
      if @user.accessible_features.where.not("name ILIKE ?", "%MockExamFeature").where("name ILIKE ?", "%ExamFeature").blank?
        false
      else
        true
      end
    end
  end

  def diagnostic_test_index?
    if @user.student?
      if @user.accessible_features.where("name ILIKE ?", "%DiagnosticsFeature").blank?
        false
      else
        true
      end
    end
  end

  def online_mock_exams_index?
    if @user.student?
      if @user.has_online_mock_feature
        true
      else
        false
      end
    end
  end

end
