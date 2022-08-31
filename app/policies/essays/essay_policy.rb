class Essays::EssayPolicy < ApplicationPolicy
  class Scope < Scope
    def initialize(user, essay_class)
      @user = user
      @essay_class = essay_class
    end

    def resolve
      if @user.student?
        []
      else
        @essay_class.all
      end
    end
  end

  def initialize(user, essay)
    @user = user
    @essay = essay
  end

  def show?
    @essay.publish? || !@user.student?
  end

  def new?
    show?
  end

  def create?
    !@user.student?
  end

  def update?
    !user.student? && !@essay.publish?
  end

  def destroy?
    !user.student? && !@essay.publish?
  end
end
