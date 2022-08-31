# Authorization for JobApplication class
class JobApplicationPolicy < ApplicationPolicy
  # Scope for JobApplication class
  class Scope < Scope
    def resolve
      scope
    end
  end

  def initialize(user, job_application)
    @user = user
    @job_application = job_application
  end

  def index?
    if @user.admin? || @user.superadmin?
      true
    else
      false
    end
  end
end
