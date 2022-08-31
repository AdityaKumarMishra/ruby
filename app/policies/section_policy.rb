class SectionPolicy < OnlineExamPolicy
  class Scope < Scope
    def initialize(user, section)
      @user = user
      @section = section
    end

    def resolve
      fail Pundit::NotAuthorizedError if @user.student?
      @section.all
    end
  end

  def initialize(user, section)
    @user = user
    @section = section
  end

  def show?
    !@user.student?
  end

  def new?
    show?
  end

  def edit?
    show?
  end

  def create?
    show?
  end

  def update?
    show?
  end

  def destroy?
    @user.admin? || @user.superadmin?
  end
end
