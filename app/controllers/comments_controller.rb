class CommentsController < ApplicationController
  before_action :authenticate_user!, except: [:create]
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = current_user.clarifications.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    if current_user
      @comment = current_user.clarifications.new(comment_params)
    else
      @comment = Comment.new(comment_params)
      if @comment.commentable_type == "TicketAnswer"
        enq_user = EnquiryUser.find_by(email: @comment.commentable.ticket.email)
        @comment.enquiry_user_id = enq_user.id if enq_user
      end
      if @comment.commentable_type == "Ticket"
        enq_user = EnquiryUser.find_by(email: @comment.commentable.email)
        @comment.enquiry_user_id = enq_user.id if enq_user
      end
    end
    authorize @comment

    respond_to do |format|
      if @comment.save
        if (current_user.nil? || current_user.student?) && @comment.commentable_type == "TicketAnswer"
          ticket = @comment.commentable.ticket
          ticket.update_attribute(:status, Ticket.statuses['unresolved'])
        end
        format.html { redirect_back fallback_location: root_path, notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
        flash[:error] = 'Please review the problems below.'
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
        flash[:error] = 'Please review the problems below.'
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to comments_url, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = Comment.find(params[:id])
    authorize @comment
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def comment_params
    params.require(:comment).permit(:content) if !current_user.nil? && current_user.student?
    params.require(:comment).permit(:commentable_id, :commentable_type, :content)
  end
end
