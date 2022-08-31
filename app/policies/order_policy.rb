class OrderPolicy < ApplicationPolicy
  class Scope < Scope
    def initialize(user, orders)
      @user = user
      @orders = orders
    end

    def resolve
      if (@user.moderator? || @user.tutor?)
        @orders.where.not(status: [Order.statuses["ongoing"], Order.statuses["free"]]).order("orders.id DESC")
      else
        created_by_user_ids=[]
        @orders.where(user: @user).each do |order|
          if order.creator.present?
            created_by_user_ids<<order.creator.id if order.creator.admin? || order.creator.superadmin? || order.creator.manager?
          end
        end
        if created_by_user_ids.blank?
          @orders.where(user: @user).where.not(status: 0)
        else
          @orders.where(user: @user).where.not(status: 0).where("creator_id IS NULL OR creator_id NOT IN (?) ",created_by_user_ids )
        end

      end
    end
  end
  def initialize(user, order)
    @user = user
    @order = order
  end

  def show?
    !@user.student? || @order.user==@user
  end

  def empty_cart?
    @user.moderator? || @order.user==@user
  end

  def paypal_complete?
    @order.total_cost != 0 && (@order.user==@user || @user.moderator?)
  end

  def direct_complete?
    @order.total_cost != 0 && (@order.user==@user || @user.moderator?)
  end

  def confirm_paid?
    @user.moderator?
  end

  def add_promo?
    !@user.student? || @order.user==@user
  end

  def remove_promo?
    !@user.student? || @order.user==@user
  end

  def redact_order?
    @order.pending? && (@order.user==@user || @user.moderator?)
  end

  def add_to_cart?
    true
  end

  def display_pending?
    @user.superadmin? || @user.admin?
  end

end
