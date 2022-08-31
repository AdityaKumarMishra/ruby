class MasterFeaturePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def initialize(user, feature)
    @user = user
    @feature = feature
  end

  def authorized?
    @user.superadmin? || @user.admin? || @user.manager?
  end

  def index?
    authorized?
  end

  def show?
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

  def master_feature_tags?
    authorized?
  end
end
