class EnrolmentPolicy < ApplicationPolicy
  class Scope < Scope
    def initialize(user, enrolment_class)
      @user = user
      @enrolment_class = enrolment_class
    end

    def resolve
      if @user.moderator?
        @enrolment_class.all
      else
        @user.paid_enrolments
      end

    end
  end

  def initialize(user, enrolment)
    @user = user
    @enrolment = enrolment
  end

  def index?
    @user.moderator?
  end

  def show?
    @user.moderator?|| @enrolment.user==@user || @enrolment.user.nil?
  end

  def new?
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

  def enrol?
    true
  end

  def quick_enrol?
    true
  end

  def attach_enrolment_details?
    true
  end

  def student_addon_enrolment?
    (@user.admin? || @user.superadmin? || @user.manager?) ? true :  false
  end

  def unenrol_or_renrol?
    student_addon_enrolment?
  end

  def student_course_enrolment?
    @user.moderator?
  end

  def transfer_by?
    @user.moderator?
  end

  def transfer_course?
    @user.moderator?
  end
  def custom_enrol?
    true
  end
end
