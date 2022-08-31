# Authorization for StaffProfile class
# Only non-student user can edit staff_profiles
class StaffProfilePolicy < ApplicationPolicy
  # Scope for index
  # Non-student can view all staff_profiles

  class Scope < Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    # Note: this returns an array, so you can't use .where etc.
    def resolve
      unless @user.student?
        @scope.all.includes(:staff).where(users: {role: 1}).order("first_name ASC")
      else
        []
      end
    end
  end

  def initialize(user, staff_profile)
    @user = user
    @staff_profile = staff_profile
  end

  def append?
    !@user.student?
  end
end
