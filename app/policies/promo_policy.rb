class PromoPolicy < ApplicationPolicy
  class Scope < Scope
    def initialize(user, promos)
      @user = user
      @promos = promos
    end

    def resolve
      if @user.moderator?
        @promos.includes(:user).where("users.role != ? OR promos.user_id IS NULL",
          User.roles[:student]).references(:users).order(created_at: :desc)
      else
        false
      end

    end
  end
  def initialize(user, promo)
    @user = user
    @promo = promo
  end

  def show?
    @user.moderator?
  end

  def create?
    @user.moderator?
  end

  def update?
    @user.moderator?
  end


  def destroy?
    @user.moderator?
  end


end
