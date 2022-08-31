class TicketPolicy < ApplicationPolicy
  class Scope < Scope
    def initialize(user, ticket_class)
      @user = user
      @ticket_class = ticket_class
    end

    def resolve
      if @user.nil?
        @ticket_class.where('public = ?', true).select { |ticket| ticket.has_access?(@user) }
      elsif @user.student?
        @ticket_class.where('public = ? or asker_id = ?', true, @user).select { |ticket| ticket.has_access?(@user) }
      else
        @ticket_class.all
      end
    end
  end

  def initialize(user, ticket)
    @user = user
    @ticket = ticket
  end

  def index?
    false
  end

  def show?
    @ticket.has_access?(@user)
  end

  def create?
    true
  end

  def new?
    create?
  end

  def update?
    @ticket.asker == @user || !@user.student?
  end

  def make_public?
    @user[:role] >= User.roles[:tutor]
  end

  def make_private?
    make_public?
  end

  def destroy?
    update?
  end

  def toggle_reminder?
    @user[:role] != User.roles[:student]
  end

  def list?
    @user.try(:has_clarity_feature).present? ? true : false
  end
end
