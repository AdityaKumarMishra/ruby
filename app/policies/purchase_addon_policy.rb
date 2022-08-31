class PurchaseAddonPolicy < ApplicationPolicy
  class Scope < Scope
    def initialize(user, purchase_addon)
      @user = user
      @purchase_addon = purchase_addon
    end

    def resolve
      @purchase_addon.all if user.superadmin? || @user.admin
    end
  end

  def initialize(user, purchase_addon)
    @user = user
    @purchase_addon = purchase_addon
  end

  def show?
    @user.superadmin? || @user.admin?
  end

  def new?
    show?
  end

  def create?
    show?
  end

  def update?
    show?
  end

  def destroy?
    show?
  end

  def paypal_payment?
     @user.student? || show?
  end

  def _purchase_addon
     @user.student? || show?
  end

end
