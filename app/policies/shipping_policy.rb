class ShippingPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def initialize(user, shipping)
    @user = user
    @shipping = shipping
  end

  def authorized?
    @user.superadmin? || @user.admin?
  end

  def index?
    authorized?
  end

  def new?
    authorized?
  end

  def edit?
    authorized?
  end

  def create?
    authorized?
  end

  def update?
    authorized?
  end

  def destroy?
    @user.superadmin?
  end

end
