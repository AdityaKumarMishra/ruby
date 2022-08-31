class AutoemailPolicy < ApplicationPolicy
  class Scope < Scope
    def initialize(user, autoemail_class)
      @user = user
      @autoemail_class = autoemail_class
    end

    def resolve
      @autoemail_class.all
      # @mcq_stem_class.select {|stem|stem.has_access? @user}
    end
  end

  def initialize(user, autoemail)
    @user = user
    @autoemail = autoemail
  end

  def index?
    @user.admin? || @user.manager?
  end

  def show?
   create?
  end

  def create?
   @user.admin? || @user.manager?
  end

  def edit?
   create?
  end

  def new?
   create?
  end

  def update?
  create?
  end

  def destroy?
   create?
  end
end
