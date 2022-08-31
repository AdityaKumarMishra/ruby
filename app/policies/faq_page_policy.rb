class FaqPagePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def initialize(user, faq)
    @user = user
    @faq = faq
  end

  def show?
    true
  end

  def create?
    @user.admin? || @user.superadmin? || @user.manager?
  end

  def edit?
    create?
  end

  def index?
    create?
  end

  def new?
    create?
  end

  def update?
    create?
  end

  def destroy?
    @user.admin? || @user.superadmin?
  end
end
