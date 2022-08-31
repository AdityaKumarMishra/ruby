class EssayTutorFeedbacksController < EssaysController
  before_action :authenticate_user!
  # before_action :check_student_essays
  before_action :set_essay_response
  before_action :set_essay
  before_action :set_essay_tutor_response, only: [:edit, :update, :show]
  before_action :set_essay_tutor_feedback, only: [:edit, :update, :show]
  # before_action :set_essay_time, except: :submit
  # layout "layouts/dashboard"
  layout :resolve_layout

  respond_to :html

  def new
    @essay_tutor_feedback = EssayTutorFeedback.new
    respond_with(@essay_tutor_feedback)
  end

  def create

    @essay_tutor_feedback = EssayTutorFeedback.new(essay_tutor_feedback_params)
    @essay_tutor_feedback.user = current_user
    @essay_tutor_feedback.essay_response=@essay_response
    @essay_response.has_feedback!
    tutor_rating = params[:essay_tutor_feedback][:rating]
    respond_to do |format|
      if @essay_tutor_feedback.save
        if tutor_rating.present? && tutor_rating.to_i <= 80
          EssayResponseMailer.essay_feedback_tutor_rating(@essay_tutor_feedback).deliver
        end
        format.html { redirect_to essay_response_path(@essay_response), notice: 'We appreciate your feedback.' }
        format.json { render :show, status: :created, location: @essay_response }
      else

        format.html { render :new }
        format.json { render json: @essay_tutor_feedback.errors, status: :unprocessable_entity }
        flash[:error] = 'Please review the problems below.'
      end
    end

  end


  def show
    respond_with(@essay_tutor_feedback)

  end
  def edit
  end

  def update
    if @essay_tutor_feedback.update(essay_tutor_feedback_params)
      respond_with(@essay_tutor_feedback, location: essay_response_path(@essay_response))
      flash[:notice] = 'EssayTutorFeedback was successfully updated.'
    else
      respond_with(@essay_tutor_feedback)
      flash[:error] = 'Please review the problems below.'
    end
  end



  private
    # def check_student_essays
    #   unless current_user.student_essays.active.pluck(:slug).include?(params[:essay_id])
    #     redirect_to essay_path, alert: 'You are not authorized.'
    #   end
    # end
    def set_essay
      @essay_response.essay
    end

    def set_essay_tutor_feedback
      @essays_tutor_feedback = EssayTutorFeedback.find(params[:id])
    end

    def set_essay_tutor_response
      @essay_tutor_feedback = @essay_response.essay_tutor_response
    end

    def set_essay_response
      @essay_response = EssayResponse.friendly.find(params[:essay_response_id])
    end



    def essay_tutor_feedback_params
      params.require(:essay_tutor_feedback).permit(:response, :id, :rating, :essay_response_id)
    end

    def resolve_layout
      case action_name
      when 'new'
        current_user.student? ? 'student_page' : 'dashboard'
      else
        'dashboard'
      end
    end

end
