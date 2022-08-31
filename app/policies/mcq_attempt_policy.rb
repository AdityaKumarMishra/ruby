class McqAttemptPolicy < ApplicationPolicy
  #code
  class Scope < Scope

    def initialize(user, mcq_attempt_class)
      @user = user
      @mcq_attempt_class = mcq_attempt_class
    end

    def resolve
      @user.mcq_attempts if @user.student?
      #code
    end
  end

  def initialize(user, mcq_attempt)
    @user = user
    @mcq_attempt = mcq_attempt
  end

  def update_answer?
    @user.student?
  end
end
