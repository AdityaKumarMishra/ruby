class McqPolicy < McqStemPolicy
  class Scope < Scope
    def initialize(user, mcq_class)
      @user = user
      @mcq_class = mcq_class
    end

    def resolve
      if @user.student?
        []
      else
        @mcq_class.all
      end
    end
  end

  def initialize(user, mcq)
    @user = user
    @mcq = mcq
    @mcq_stem = mcq.mcq_stem
  end

  def complete_stem?
    !@user.student?
  end
end
