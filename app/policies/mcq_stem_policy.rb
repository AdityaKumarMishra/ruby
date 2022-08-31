class McqStemPolicy < ApplicationPolicy
  class Scope < Scope
    def initialize(user, mcq_stem_class)
      @user = user
      @mcq_stem_class = mcq_stem_class
    end

    def resolve
      @mcq_stem_class.all
      # @mcq_stem_class.select {|stem|stem.has_access? @user}
    end
  end

  def initialize(user, mcq_stem)
    @user = user
    @mcq_stem = mcq_stem
  end

  def index?
    !@user.student?
  end

  def log_hours?
    !@user.student?
  end

  def create_mcq_hour?
    !@user.student?
  end

  def delete_last_mcq_hour?
    !@user.student?
  end

  def show?
    @mcq_stem.has_access? @user
  end

  def create?
    !@user.student?
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
