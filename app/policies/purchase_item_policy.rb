class PurchaseItemPolicy < ApplicationPolicy
  class Scope < Scope
    def initialize(user, purchase_items)
      @user = user
      @purchase_items = purchase_items
    end

    def resolve
      if @user.moderator? {|c| !c.ongoing?}
        @purchase_items.select
      else
        @purchase_items.select {|c| c.user==@user}
      end
    end
  end
  def initialize(user, purchase_item)
    @user = user
    @purchase_item = purchase_item
  end

  def show?
    @user.moderator? || @purchase_item.user==@user
  end

  def create?
    @user.moderator?
  end

  def update?
    @user.moderator?
  end

  def destroy?
    if @purchase_item.order.ongoing?
      (@user==@purchase_item.order.user)||(@user.moderator?)
    else
      @user.moderator?
    end

  end
end
