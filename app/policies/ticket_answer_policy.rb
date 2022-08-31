class TicketAnswerPolicy < ApplicationPolicy
  class Scope < Scope
    def initialize(user, ticket_answers)
      @user = user
      @ticket_answers = ticket_answers
    end

    def resolve
      if @user.student?
        @ticket_answers.where(public: true)
      else
        @ticket_answers.all
      end
    end
  end
  def initialize(user, ticket_answer)
    @user = user
    @ticket_answer = ticket_answer
  end

  def show?
    @ticket_answer.public? || !@user.student?
  end

  def create?
    !@user.student?
  end

  def update?
    !@user.student?
  end

  def destroy?
    !@user.student?
  end
end
