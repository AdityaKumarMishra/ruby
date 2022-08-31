class SectionItemPolicy < SectionPolicy
  # class Scope < Scope
  #   def resolve
  #     scope
  #   end
  # end

  def initialize(user, section_item)
    @user = user
    @section_item = section_item
  end

  def create?
    !@user.student?
  end

  def show?
    !@user.student?
  end

  def update?
    create?
  end

  def edit?
    create?
  end

  def destroy?
    create?
  end

  def remove_question?
    create?
  end
end
