class EssaysController < ApplicationController
  before_action :authenticate_user!
  before_action :set_essay, only: [:show, :edit, :update, :destroy]
  # before_action :not_authorised_user, only: [:new, :edit, :update, :destroy, :f, :tutor_rate, :collect_tutor_rate], :if => proc{!current_user.tutor?}
  before_action :set_essay_for_answer, only: [:collect_student_answer, :student_answer, :tutor_rate, :collect_tutor_rate]
  before_action :set_product_lines, only: %i[new edit create update show update_product_line_positions]

  layout "layouts/dashboard"

  respond_to :html
#TODO add policies for this controller
  def index
    @essays = Essay.all.order("id ASC").paginate(page: params[:page], per_page: 10)
    redirect_to dashboard_home_path and return if current_user.student?
  end

  def show
    # note this might be a m+1 problem here, need to confirm
    essay_responses = @essay.essay_responses
    @marked_responses = @essay.marked_responses(current_user, essay_responses)
    @marked = @marked_responses.to_a.sort_by{|x| x.time_submited.in_time_zone("Australia/Melbourne")}.reverse

    @unanswered_responses = @essay.unanswered_responses(current_user)
    @unmarked_responses = @essay.unmarked_responses(current_user)
    @unmarked = @unmarked_responses.to_a.sort_by{|x| x.time_submited.in_time_zone("Australia/Melbourne")}.reverse

    @resp = (@unmarked + @marked).paginate(page: params[:page], per_page: 20)
    respond_with(@essay)
  end

  def new
    @essay = Essay.new
    respond_with(@essay)
  end

  def edit
  end

  def create
    @essay = Essay.new(essay_params)
    @essay.tutor_id = current_user.id
    if @essay.save
      flash[:notice] = 'Essay was successfully created.'
    else
      flash[:error] = 'Please review the problems below.'
    end
    respond_with(@essay)
  end

  def update
    @essay.update(essay_params)
    respond_with(@essay)
  end

  def destroy
    @essay.destroy
    respond_with(@essay)
  end

  def student_answer

  end

  def collect_student_answer
    respond_to do |format|
      unless @essay.nil?
        @essay.transaction do
          essay_response = EssayResponse.new essay_response_params
          essay_response.user = current_user
          essay_response.save!
          @essay.update_columns :essay_responses_id => essay_response.id
          format.html {redirect_to dashboard_path, notice: 'Thank you for your answers.'}
          format.json { render :show, status: :created, location: @essay }
        end
      end
    end
  end

  def all_responses
    @responses = EssayEssayResponse.all
  end

  def update_product_line_positions
    @product_line = ProductLine.find(params[:product_line_id].to_i)
    @essay = Essay.find_by(id: params[:essay_id].to_i) || Essay.new

    respond_to do |format|
      format.js
    end
  end


  def tutor_rate
    if @essay.tutor = current_user
      tutor_response = EssayTutorResponse.new essay_tutor_response_params
      tutor_response.save!
      format.html {redirect_to dashboard_path, notice: 'Thank you for your answers.'}
      format.json { render :show, status: :created, location: @essay }
    else
      format.html { redirect_to dashboard_path, notice: 'There has been an error.' }
      format.json { render json: 'There has been an error.', status: :unprocessable_entity }
    end
  end

  def collect_tutor_rate
    render :nothing => true
  end

  def filter_essays
    unmarked_count = []
    no_unmarked_count = []
    if params[:selected] == "Both"
      @essays = Essay.all
    else
      Essay.all.each do |essay|
        if essay.essay_responses.present? && essay.essay_responses.unmarked_responses.present?
          if essay.essay_responses.unmarked_responses.count > 0
            unmarked_count << essay
          else
            no_unmarked_count << essay
          end
        end
      end
      if params[:selected] ==  "True"
        @essays = unmarked_count
      elsif params[:selected] == "False"
        @essays = no_unmarked_count
      end
    end
    @essays = @essays.paginate(:page => params[:page] || 1, :per_page => 10)
    render :nothing => true
  end

  def tag_filter
    essay_with_tag = []
    Essay.all.each do |essay|
      if essay.taggings.present?
        essay.taggings.all.each do |tag|
          if tag.tag_id == params[:selected].to_i
            essay_with_tag << tag.taggable
          end
        end
      end
    end
    @essays = essay_with_tag
    render :nothing => true
  end

  private
    def set_product_lines
      @product_lines = ProductLine.all
    end

    def set_essay
      @essay = Essay.friendly.find(params[:id])
    end

    def essay_params
      params.require(:essay).permit(:title, :question, :product_line_id, :date_added, :expiration_date, :position, tag_ids: [],
                                    tags_attributes: [ :id, :name, :description, :parent_id, :_destroy ])
    end

    def essay_response_params
      params.require(:essay_response).permit(:response, :time_submited)
    end

    def essay_tutor_response_params
      params.require(:essay_tutor_response).permit(:response, :rating, :essay_response_id)
    end

  def set_essay_for_answer
    @essay = Essay.find(params[:essay_id])
    if @essay.nil?
      format.html { redirect_to dashboard_path, alert: "Essay #{params[:essay_id]} no found" }
      format.json { render json: "Essay #{params[:essay_id]} no found", status: :unprocessable_entity }
    end
  end
end
