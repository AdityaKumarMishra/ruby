class CommentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def initialize(user, comment)
    @user = user
    @comment = comment
  end

  def show?
    if @user.student?
      @comment.commentable.public? || @comment.user == @user
    else
      true
    end
  end

  def create?
    if @comment.commentable
      if @user && @user.student?
        @comment.commentable.user == @user || @comment.commentable.public? || @comment.user == @user
      else
        true
      end
    else
      false
    end
  end

  def update?
    if @user.student?
      @comment.user == @user
    else
      true
    end
  end

  def destroy?
    update?
  end
end
