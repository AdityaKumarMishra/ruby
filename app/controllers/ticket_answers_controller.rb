class TicketAnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_ticket
  before_action :set_ticket_answer, only: [:show, :edit, :update, :destroy]

  # GET /ticket_answers
  # GET /ticket_answers.json
  def index
    @ticket_answers = policy_scope(TicketAnswer).where(ticket: @ticket)
  end

  # GET /ticket_answers/1
  # GET /ticket_answers/1.json
  def show
  end

  # GET /ticket_answers/new
  def new
    @ticket_answer = @ticket.ticket_answers.new
  end

  # GET /ticket_answers/1/edit
  def edit
  end

  # POST /ticket_answers
  # POST /ticket_answers.json
  def create
    @ticket_answer = @ticket.ticket_answers.new(ticket_answer_params)
    @ticket_answer.user = current_user
    authorize @ticket_answer
    respond_to do |format|
      if @ticket_answer.save
        format.html { redirect_to url_for(action: :show, controller: :issue_forum, params: {id: @ticket_answer.ticket.id}), notice: 'Ticket was successfully created.' }
        # format.html { redirect_to ticket_ticket_answer_url(@ticket, @ticket_answer), notice: 'Ticket answer was successfully created.' }
        format.json { render :show, status: :created, location: @ticket_answer }
      else
        format.html { render :new }
        format.json { render json: @ticket_answer.errors, status: :unprocessable_entity }
        flash[:error] = 'Please review the problems below.'
      end
    end
  end

  # PATCH/PUT /ticket_answers/1
  # PATCH/PUT /ticket_answers/1.json
  def update
    respond_to do |format|
      if @ticket_answer.update(ticket_answer_params)
        TicketMailer.new_answer(@ticket_answer).deliver_later if @ticket_answer.changed_to_public? && ENV['EMAIL_CONFIRMABLE'] != "false"
        format.html { redirect_to url_for(action: :show, controller: :issue_forum, params: {id: @ticket_answer.ticket.id}), notice: 'Ticket was successfully created.' }
        # format.html { redirect_to ticket_ticket_answer_url(@ticket, @ticket_answer), notice: 'Ticket answer was successfully updated.' }
        format.json { render :show, status: :ok, location: @ticket_answer }
      else
        format.html { render :edit }
        format.json { render json: @ticket_answer.errors, status: :unprocessable_entity }
        flash[:error] = 'Please review the problems below.'
      end
    end
  end

  # DELETE /ticket_answers/1
  # DELETE /ticket_answers/1.json
  def destroy
    @ticket_answer.destroy
    respond_to do |format|
      format.html { redirect_to ticket_ticket_answers_url(@ticket), notice: 'Ticket answer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def find_helpful
    @ticket_answer = @ticket.ticket_answers.find(params[:id])
    vote = Vote.new(votable: @ticket_answer, user: current_user)
    respond_to do |format|
      if vote.save
        format.html {redirect_back fallback_location: root_path}
        format.json { render json: vote, status: :created }
      else
        format.html {redirect_back fallback_location: root_path}
        format.json { render json: v.errors, status: :unprocessable_entity  }
      end
    end
  end

  private

  def set_ticket
    @ticket = Ticket.find(params[:ticket_id])
  end

  def set_ticket_answer
    @ticket_answer = @ticket.ticket_answers.find(params[:id])
    authorize @ticket_answer
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def ticket_answer_params
    params.require(:ticket_answer).permit(:content, :public)
  end
end
