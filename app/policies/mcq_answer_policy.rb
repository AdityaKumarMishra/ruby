class McqAnswerPolicy < McqStemPolicy
  class Scope < Scope
    def initialize(user, mcq_answer_class)
      @user = user
      @mcq_answer_class = mcq_answer_class
    end

    def resolve
      if @user.student?
        []
      else
        @mcq_answer_class.all
      end
    end
  end

  def initialize(user, mcq_answer)
    @user = user
    @mcq_answer = mcq_answer
    @mcq_stem = mcq_answer.mcq.mcq_stem
  end
end
