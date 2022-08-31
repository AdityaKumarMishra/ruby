class UserPolicy < ApplicationPolicy
  class Scope < Scope
    attr_reader :user, :scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if @user.superadmin?
        scope.all
      elsif @user.admin?
        scope.where.not(role: [scope.roles['superadmin']])
      elsif @user.manager?
        scope.where(role: [scope.roles['manager'],scope.roles['tutor'],scope.roles['student']])
      elsif @user.tutor?
        scope.where(role: [scope.roles['tutor'],scope.roles['student']])
      else
        scope.where(id: @user.id)
      end
    end
  end

  def initialize(current_user, user)
    @current_user = current_user
    @user = user
  end

  def new?
    true
  end

  def create?
    if @current_user.superadmin?
      return true
    elsif @current_user.admin?
      return !@user.superadmin?
    elsif @current_user.manager?
      return !@user.superadmin? && !@user.admin?
    end
    false
  end

  def edit?
    return true if self?
    if @current_user.manager?
      !@user.admin? && !@user.superadmin?
    elsif @current_user.admin?
      !@user.superadmin?
    elsif @current_user.superadmin?
      true
    else
      false
    end
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

  def deactivate?
    edit?
  end

  def resend_invitation?
    edit?
  end

  def generate_new_password_email?
    @user.student?
  end

  def become?
    @current_user.admin? || @current_user.superadmin? ||  @current_user.manager? || @current_user.tutor?
  end

  def update_contact?
    edit?
  end

  def save_detail?
    edit?
  end

  def course_details?
    edit?
  end

  def transfer_data?
    edit?
  end

  def transfer?
    edit?
  end

  private



  def self?
    @current_user == @user
  end
end
