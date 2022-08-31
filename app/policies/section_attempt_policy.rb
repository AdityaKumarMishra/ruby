class SectionAttemptPolicy < ApplicationPolicy
  class Scope < Scope
    def initialize(user, section_attempt_class)
      @user = user
      @section_attempt_class = section_attempt_class
    end

    def resolve
      fail Pundit::NotAuthorizedError unless @user.student?
      @user.section_attempts
    end
  end

  def initialize(user, section_attempt)
    @user = user
    @section_attempt = section_attempt
  end

  def show?
    @section_attempt.user == @user
  end

  def complete?
    @section_attempt.completed_at.nil?
  end

  def review?
    !complete?
  end
end
